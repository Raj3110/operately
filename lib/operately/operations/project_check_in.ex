defmodule Operately.Operations.ProjectCheckIn do
  alias Ecto.Multi

  alias Operately.Repo
  alias Operately.Activities
  alias Operately.Projects.{CheckIn, Project}
  alias Operately.Notifications.{SubscriptionList, Subscription}

  def run(author, project, attrs) do
    next_check_in = Operately.Time.calculate_next_weekly_check_in(
      project.next_check_in_scheduled_at,
      DateTime.utc_now()
    )

    Multi.new()
    |> Multi.insert(:subscription_list, SubscriptionList.changeset(%{
      send_to_everyone: attrs.send_notifications_to_everyone,
    }))
    |> insert_author_subscription(author.id)
    |> insert_subscriptions(attrs.subscriber_ids)
    |> insert_mentioned_subscriptions(attrs.description)
    |> Multi.insert(:check_in, fn changes ->
      CheckIn.changeset(%{
        author_id: author.id,
        project_id: project.id,
        status: attrs.status,
        description: attrs.description,
        subscription_list_id: changes.subscription_list.id,
      })
    end)
    |> Multi.update(:updated_subscription_list, fn changes ->
      SubscriptionList.changeset(changes.subscription_list, %{
        parent_type: :project_check_in,
        parent_id: changes.check_in.id,
      })
    end)
    |> Multi.update(:project, fn changes ->
      Project.changeset(project, %{
        last_check_in_id: changes.check_in.id,
        last_check_in_status: changes.check_in.status,
        next_check_in_scheduled_at: next_check_in,
      })
    end)
    |> Activities.insert_sync(author.id, :project_check_in_submitted, fn changes ->
      %{
        company_id: project.company_id,
        project_id: project.id,
        check_in_id: changes.check_in.id
      }
    end)
    |> Repo.transaction()
    |> Repo.extract_result(:check_in)
    |> case do
      {:ok, check_in} ->
        OperatelyWeb.ApiSocket.broadcast!("api:assignments_count:#{author.id}")
        {:ok, check_in}

      error -> error
    end
  end

  defp insert_author_subscription(multi, author_id) do
    Multi.insert(multi, :author_subscription, fn changes ->
      Subscription.changeset(%{
        subscription_list_id: changes.subscription_list.id,
        person_id: author_id,
        type: :invited,
      })
    end)
  end

  defp insert_subscriptions(multi, nil), do: multi
  defp insert_subscriptions(multi, subscriber_ids) do
    Enum.reduce(subscriber_ids, multi, fn id, multi ->
      name = "subscription_" <> id

      Multi.insert(multi, name, fn changes ->
        Subscription.changeset(%{
          subscription_list_id: changes.subscription_list.id,
          person_id: id,
          type: :invited,
        })
      end)
    end)
  end

  defp insert_mentioned_subscriptions(multi, description) do
    {:ok, ids} =
      description
      |> Operately.RichContent.find_mentioned_ids()
      |> Enum.uniq()
      |> OperatelyWeb.Api.Helpers.decode_id()

    Enum.reduce(ids, multi, fn id, multi ->
      name = "mentioned_subscription_" <> id

      Multi.insert(multi, name, fn changes ->
        Subscription.changeset(%{
          subscription_list_id: changes.subscription_list.id,
          person_id: id,
          type: :mentioned,
        })
      end)
    end)
  end
end
