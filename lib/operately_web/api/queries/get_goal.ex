defmodule OperatelyWeb.Api.Queries.GetGoal do
  use TurboConnect.Query
  use OperatelyWeb.Api.Helpers

  import Operately.Access.Filters, only: [filter_by_view_access: 2]

  alias OperatelyWeb.Api.Serializer
  alias Operately.Goals.Goal

  inputs do
    field :id, :string

    field :include_champion, :boolean
    field :include_closed_by, :boolean
    field :include_last_check_in, :boolean
    field :include_permissions, :boolean
    field :include_projects, :boolean
    field :include_reviewer, :boolean
    field :include_space, :boolean
    field :include_space_members, :boolean
    field :include_targets, :boolean
    field :include_access_levels, :boolean
  end

  outputs do
    field :goal, :goal
  end

  def call(conn, %{id: id} = inputs) do
    {:ok, id} = decode_id(id)
    goal = load(id, me(conn), inputs)

    if goal do
      output = %{goal: Serializer.serialize(goal, level: :full)}
      {:ok, output}
    else
      {:error, :not_found}
    end
  end

  def call(_conn, _) do
    {:error, :bad_request}
  end

  defp load(id, person, inputs) do
    include_filters = extract_include_filters(inputs)
    query = from(g in Goal, as: :goal, where: g.id == ^id, preload: [:parent_goal])

    query
    |> Goal.scope_company(person.company_id)
    |> include_requested(include_filters)
    |> filter_by_view_access(person.id)
    |> Repo.one(with_deleted: true)
    |> load_last_check_in(inputs[:include_last_check_in])
    |> load_permissions(person, inputs[:include_permissions])
    |> load_access_levels(inputs[:include_access_levels])
  end

  defp include_requested(query, requested) do
    Enum.reduce(requested, query, fn include, q ->
      case include do
        :include_champion -> from p in q, preload: [:champion]
        :include_closed_by -> from p in q, preload: [:closed_by]
        :include_last_check_in -> q # this is done after the load
        :include_permissions -> q # this is done after the load
        :include_projects -> from p in q, preload: [projects: [:champion, :reviewer]]
        :include_reviewer -> from p in q, preload: [:reviewer]
        :include_space -> from p in q, preload: [:group]
        :include_space_members -> from p in q, preload: [group: [:members, :company]]
        :include_targets -> from p in q, preload: [:targets]
        :include_access_levels -> q # this is done after the load
        _ -> raise "Unknown include filter: #{inspect(include)}"
      end
    end)
  end

  defp load_last_check_in(nil, _), do: nil
  defp load_last_check_in(goal, true), do: Goal.preload_last_check_in(goal)
  defp load_last_check_in(goal, _), do: goal

  defp load_permissions(nil, _, _), do: nil
  defp load_permissions(goal, person, true), do: Goal.preload_permissions(goal, person)
  defp load_permissions(goal, _, _), do: goal

  defp load_access_levels(nil, _), do: nil
  defp load_access_levels(goal, true), do: Goal.preload_access_levels(goal)
  defp load_access_levels(goal, _), do: goal
end
