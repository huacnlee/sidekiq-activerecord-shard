require "test_helper"
class SidekiqTest < ActionDispatch::IntegrationTest
  test "Create job in Primary shard" do
    Current.tenant_id = "primary"
    post = nil
    ActiveRecord::Base.connected_to(shard: Current.tenant_id.to_sym) do
      post = Post.create!(title: "Title")
    end

    assert_equal "Title", post.title
    AsyncPostWorker.perform_async(post.id)

    ActiveRecord::Base.connected_to(shard: Current.tenant_id.to_sym) do
      post.reload
    end
    assert_equal "Update Title in Sidekiq tenant: primary, database: dummy_primary_test", post.title
  end

  test "Create job in Other shard" do
    Current.tenant_id = "other"
    post = nil
    ActiveRecord::Base.connected_to(shard: Current.tenant_id.to_sym) do
      post = Post.create!(title: "Title")
    end

    assert_equal "Title", post.title
    AsyncPostWorker.perform_async(post.id)

    ActiveRecord::Base.connected_to(shard: Current.tenant_id.to_sym) do
      post.reload
    end
    assert_equal "Update Title in Sidekiq tenant: other, database: dummy_other_test", post.title
  end

  test "perform with set _active_record_shard" do
    post = nil
    ActiveRecord::Base.connected_to(shard: :other) do
      post = Post.create!(title: "Title")
    end

    AsyncPostWorker.set(shard: "other").perform_async(post.id)
    ActiveRecord::Base.connected_to(shard: :other) do
      post.reload
    end

    assert_equal "Update Title in Sidekiq tenant: , database: dummy_other_test", post.title
  end
end
