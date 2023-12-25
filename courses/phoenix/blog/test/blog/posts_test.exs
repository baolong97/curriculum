defmodule Blog.PostsTest do
  use Blog.DataCase

  alias Blog.Posts

  describe "posts" do
    alias Blog.Posts.Post

    import Blog.PostsFixtures

    @invalid_attrs %{title: nil, subtitle: nil, content: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "list_posts/0 returns all posts with visible: true" do
      post_fixture(%{visible: false})
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "list_posts/0 posts are displayed from newest" do
      posts = Enum.map(1..10,fn i ->  post_fixture(%{title: "title #{i}"}) end)
      is_newest_to_oldest = posts
      |>Enum.chunk_every(2, 1, :discard)
      |>Enum.all?(fn [p1,p2]->
        p1.inserted_at >= p2.inserted_at
      end)

      assert is_newest_to_oldest
    end

    test "list_posts/0 posts with a published date in the future are filtered from the list of posts" do
      post_fixture(%{published_on: ~D[2023-12-26]})
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "list_posts/1 filters posts by partial and case-insensitive title" do
      post = post_fixture(title: "Title #{NaiveDateTime.utc_now}")

      # non-matching
      assert Posts.list_posts("Non-Matching") == []
      # exact match
      assert Posts.list_posts("Title") == [post]
      # partial match end
      assert Posts.list_posts("tle") == [post]
      # partial match front
      assert Posts.list_posts("Titl") == [post]
      # partial match middle
      assert Posts.list_posts("itl") == [post]
      # case insensitive lower
      assert Posts.list_posts("title") == [post]
      # case insensitive upper
      assert Posts.list_posts("TITLE") == [post]
      # case insensitive and partial match
      assert Posts.list_posts("ITL") == [post]
      # empty
      assert Posts.list_posts("") == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      title = "some title #{NaiveDateTime.utc_now}"
      valid_attrs = %{
        title: title,
        content: "some content",
        published_on: ~D[2023-12-12],
        visible: true
      }

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.title == title
      assert post.content == "some content"
      assert post.published_on == ~D[2023-12-12]
      assert post.visible == true
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      title = "some title #{NaiveDateTime.utc_now}"

      post = post_fixture()

      update_attrs = %{
        title: title,
        content: "some content",
        published_on: ~D[2023-12-23],
        visible: false
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.title == title
      assert post.content == "some content"
      assert post.published_on == ~D[2023-12-23]
      assert post.visible == false
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
