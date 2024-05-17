defmodule Operately.Operations.GoalDiscussionEditing do
  alias Ecto.Multi
  alias Operately.Repo
  alias Operately.Activities

  @action :goal_discussion_editing

  def run(author, activity_id, title, message) do
    activity = Operately.Activities.get_activity!(activity_id)
    goal = Operately.Goals.get_goal!(activity.content["goal_id"])
    comment_thread = Operately.Comments.get_thread!(activity.comment_thread_id)

    change = Operately.Comments.CommentThread.changeset(comment_thread, %{
      title: title,
      message: Jason.decode!(message),
    })

    Multi.new()
    |> Multi.update(:thread, change)
    |> Multi.insert(:activity, Activities.Activity.changeset(%{
      author_id: author.id,
      action: Atom.to_string(@action),
      content: Activities.build_content!(@action, %{
        company_id: goal.company_id,
        space_id: goal.group_id,
        goal_id: goal.id,
        activity_id: activity_id,
      })
    }))
    |> Repo.transaction()
    |> Repo.extract_result(:activity)
  end
end
