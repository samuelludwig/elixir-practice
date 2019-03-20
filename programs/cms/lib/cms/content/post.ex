defmodule Cms.Content.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :slug}

  schema "posts" do
    field :body, :string
    field :cover, :string
    field :published, :boolean, default: false
    field :slug, :string
    field :title, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :published, :cover, :user_id, :slug])
    |> validate_required([:title, :body, :published, :cover, :user_id, :slug])
  end

  def create_changeset(post, attrs) do
    post
    |> common_changeset(attrs)
    |> validate_required([:user_id, :cover])
  end

  def common_changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [:title, :body, :published, :user_id])
    |> cast_attachments(attrs, [:cover])
    |> validate_required([:title, :body])
    |> validate_length(:title, min: 3)
    |> process_slug
  end

  # Private

  defp process_slug(%Ecto.Changeset{valid?: validity, changes: %{title: title}} = changeset) do
    case validity do
      true -> put_change(changeset, :slug, Slugger.slugify_downcase(title))
      false -> changeset
    end
  end

  defp process_slug(changeset), do: changeset

end
