defmodule BlogWeb.CommentController do
  use BlogWeb, :controller

  alias Blog.Comments
  alias Blog.Comments.Comment

  alias Blog.Posts

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, :index, comments: comments)
  end

  def new(conn, _params) do
    changeset = Comments.change_comment(%Comment{})
    render(conn, :new, changeset: changeset)
  end

  def add_comment(conn, params) do
    post = Posts.get_post!(params["id"])
    IO.inspect(post)
    changeset = Comments.change_comment(%Comment{})
    IO.inspect(changeset)
    render(conn, :add_comment, changeset: changeset, post: post)
  end

  def create(conn, %{"comment" => comment_params}) do
    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: ~p"/posts/#{comment_params["post_id"]}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, :show, comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    changeset = Comments.change_comment(comment)
    render(conn, :edit, comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: ~p"/comments/#{comment}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    {:ok, comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: ~p"/posts/#{comment.post_id}")
  end
end
