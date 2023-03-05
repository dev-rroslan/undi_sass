defmodule Undi.Accounts.Account do
  @moduledoc """
  The Account Schema
  """
  use Undi.Schema
  import Ecto.Changeset
  @derive {
    Flop.Schema,
    default_limit: 20,
    filterable: [:name],
    sortable: [:name]
  }
  schema "accounts" do
    field :name, :string
    field :personal, :boolean, default: false

    belongs_to :created_by, Undi.Users.User, foreign_key: :created_by_user_id
    has_many :memberships, Undi.Accounts.Membership
    has_many :members, through: [:memberships, :member]

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :personal])
    |> validate_required([:name, :personal])
    |> unique_constraint(:personal, name: :accounts_limit_personal_index)
  end
end
