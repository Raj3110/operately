defmodule OperatelyWeb.Graphql.Schema do
  #
  # This file is generated by: mix operately.gen.elixir.graphql.schema
  # Do not edit this file directly.
  #

  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  # Types
  import_types OperatelyWeb.Graphql.Types.ActivityContent
  import_types OperatelyWeb.Graphql.Types.Assignments
  import_types OperatelyWeb.Graphql.Types.Blobs
  import_types OperatelyWeb.Graphql.Types.CommentThreads
  import_types OperatelyWeb.Graphql.Types.Comments
  import_types OperatelyWeb.Graphql.Types.Companies
  import_types OperatelyWeb.Graphql.Types.Discussions
  import_types OperatelyWeb.Graphql.Types.GoalPermissions
  import_types OperatelyWeb.Graphql.Types.Goals
  import_types OperatelyWeb.Graphql.Types.Groups
  import_types OperatelyWeb.Graphql.Types.Invitations
  import_types OperatelyWeb.Graphql.Types.Milestones
  import_types OperatelyWeb.Graphql.Types.Person
  import_types OperatelyWeb.Graphql.Types.ProjectCheckIn
  import_types OperatelyWeb.Graphql.Types.ProjectHealths
  import_types OperatelyWeb.Graphql.Types.ProjectPermissions
  import_types OperatelyWeb.Graphql.Types.Projects
  import_types OperatelyWeb.Graphql.Types.Reactions
  import_types OperatelyWeb.Graphql.Types.Tasks
  import_types OperatelyWeb.Graphql.Types.Timeframe
  import_types OperatelyWeb.Graphql.Types.UpdateContentGoalCheckIn
  import_types OperatelyWeb.Graphql.Types.UpdateContentMessage
  import_types OperatelyWeb.Graphql.Types.UpdateContentProjectContributorAdded
  import_types OperatelyWeb.Graphql.Types.UpdateContentProjectContributorRemoved
  import_types OperatelyWeb.Graphql.Types.UpdateContentProjectCreated
  import_types OperatelyWeb.Graphql.Types.UpdateContentProjectDiscussion
  import_types OperatelyWeb.Graphql.Types.UpdateContentProjectEndTimeChanged
  import_types OperatelyWeb.Graphql.Types.UpdateContentProjectMilestoneCompleted
  import_types OperatelyWeb.Graphql.Types.UpdateContentProjectMilestoneCreated
  import_types OperatelyWeb.Graphql.Types.UpdateContentProjectMilestoneDeadlineChanged
  import_types OperatelyWeb.Graphql.Types.UpdateContentProjectMilestoneDeleted
  import_types OperatelyWeb.Graphql.Types.UpdateContentProjectStartTimeChanged
  import_types OperatelyWeb.Graphql.Types.UpdateContentReview
  import_types OperatelyWeb.Graphql.Types.UpdateContentStatusUpdate
  import_types OperatelyWeb.Graphql.Types.Updates

  # Queries
  import_types OperatelyWeb.Graphql.Queries.Assignments
  import_types OperatelyWeb.Graphql.Queries.Comments
  import_types OperatelyWeb.Graphql.Queries.Companies
  import_types OperatelyWeb.Graphql.Queries.Discussions
  import_types OperatelyWeb.Graphql.Queries.Goals
  import_types OperatelyWeb.Graphql.Queries.Groups
  import_types OperatelyWeb.Graphql.Queries.Invitations
  import_types OperatelyWeb.Graphql.Queries.KeyResources
  import_types OperatelyWeb.Graphql.Queries.Milestones
  import_types OperatelyWeb.Graphql.Queries.People
  import_types OperatelyWeb.Graphql.Queries.ProjectCheckIns
  import_types OperatelyWeb.Graphql.Queries.Projects
  import_types OperatelyWeb.Graphql.Queries.Tasks
  import_types OperatelyWeb.Graphql.Queries.Updates

  # Mutations
  import_types OperatelyWeb.Graphql.Mutations.Accounts
  import_types OperatelyWeb.Graphql.Mutations.Blobs
  import_types OperatelyWeb.Graphql.Mutations.Comments
  import_types OperatelyWeb.Graphql.Mutations.Companies
  import_types OperatelyWeb.Graphql.Mutations.Discussions
  import_types OperatelyWeb.Graphql.Mutations.Goals
  import_types OperatelyWeb.Graphql.Mutations.Groups
  import_types OperatelyWeb.Graphql.Mutations.Milestones
  import_types OperatelyWeb.Graphql.Mutations.ProjectCheckIns
  import_types OperatelyWeb.Graphql.Mutations.Projects
  import_types OperatelyWeb.Graphql.Mutations.Reactions
  import_types OperatelyWeb.Graphql.Mutations.Tasks
  import_types OperatelyWeb.Graphql.Mutations.Updates

  # Subscriptions
  import_types OperatelyWeb.Graphql.Subscriptions.Notifications

  query do
    import_fields :assignment_queries
    import_fields :comment_queries
    import_fields :company_queries
    import_fields :discussion_queries
    import_fields :goal_queries
    import_fields :group_queries
    import_fields :invitation_queries
    import_fields :key_resource_queries
    import_fields :milestone_queries
    import_fields :person_queries
    import_fields :project_check_in_queries
    import_fields :project_queries
    import_fields :task_queries
    import_fields :update_queries
  end

  mutation do
    import_fields :account_mutations
    import_fields :blob_mutations
    import_fields :comment_mutations
    import_fields :company_mutations
    import_fields :discussion_mutations
    import_fields :goal_mutations
    import_fields :group_mutations
    import_fields :milestone_mutations
    import_fields :project_check_in_mutations
    import_fields :project_mutations
    import_fields :reaction_mutations
    import_fields :task_mutations
    import_fields :update_mutations
  end

  subscription do
    import_fields :notification_subscriptions
  end

  # Autogenerated middleware wrapping
  def middleware(middleware, _field, _object), do: OperatelyWeb.Graphql.Middlewares.ExceptionHandler.wrap_all_middlewares(middleware)
end
