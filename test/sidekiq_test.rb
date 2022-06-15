class SidekiqTest < ActionDispatch::IntegrationTest
  test "Create job in Primary shard" do
    Current.tenant_id = "primary"
    post = Post.create!(title: "Title")
    assert_equal "Title", post.title

    AsyncPostWorker.perform_async(post.id)

    post.reload
    assert_equal "Update Title in Sidekiq tenant: primary", post.title
  end

  test "Create job in Other shard" do
    Current.tenant_id = "other"
    post = Post.create!(title: "Title")
    assert_equal "Title", post.title

    AsyncPostWorker.perform_async(post.id)

    post.reload
    assert_equal "Update Title in Sidekiq tenant: other", post.title
  end
end
