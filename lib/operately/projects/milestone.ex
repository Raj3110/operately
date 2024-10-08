defmodule Operately.Projects.Milestone do
  use Operately.Schema

  schema "project_milestones" do
    belongs_to :project, Operately.Projects.Project
    has_one :access_context, through: [:project, :access_context]

    has_many :tasks, Operately.Tasks.Task

    field :title, :string
    field :status, Ecto.Enum, values: [:pending, :done], default: :pending
    field :phase, Ecto.Enum, values: [:concept, :planning, :execution, :control], default: :concept

    field :deadline_at, :naive_datetime
    field :completed_at, :naive_datetime

    field :description, :map
    field :tasks_kanban_state, :map, default: Operately.Tasks.KanbanState.initialize()

    has_many :comments, Operately.Comments.MilestoneComment

    timestamps()
    soft_delete()
    requester_access_level()
  end

  def changeset(attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(milestone, attrs) do
    milestone
    |> cast(attrs, [:title, :deadline_at, :project_id, :status, :completed_at, :deleted_at, :description, :tasks_kanban_state])
    |> validate_required([:title, :tasks_kanban_state, :project_id])
  end
end
