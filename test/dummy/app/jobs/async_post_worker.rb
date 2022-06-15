class AsyncPostWorker
  include Sidekiq::Worker

  def perform(post_id)
    post = Post.find(post_id)
    post.update(title: "Update Title in Sidekiq tenant: #{Current.tenant_id}")
  end
end
