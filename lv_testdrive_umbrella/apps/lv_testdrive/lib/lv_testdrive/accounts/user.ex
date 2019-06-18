defmodule LvTestdrive.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias LvTestdrive.Accounts.Credential

  schema "users" do
    field :name, :string
    field :username, :string
    field :counter, :integer
    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

  # def changeset(user, attrs) do
  #   user
  #   |> cast(attrs, [])
  # end
end
