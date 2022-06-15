require "sidekiq"

module SidekiqActiveRecordShard
  class Client
    include Sidekiq::ClientMiddleware

    def call(_jobclass, job, _queue, _redis)
      # Store shard value in Job arguments
      shard = SidekiqActiveRecordShard.config.selected_shard.call
      if shard.nil?
        raise "No shard selected, SidekiqActiveRecordShard.config.selected_shard return nil."
      end

      job["_active_record_shard"] = shard
      yield
    end
  end

  class Server
    include Sidekiq::ServerMiddleware
    def call(_jobclass, job, _queue, &block)
      set_shard(job["_active_record_shard"], &block)
    end

    # Inspired by ActiveRecord::Middleware::ShardSelector
    # https://github.com/rails/rails/blob/v7.0.3/activerecord/lib/active_record/middleware/shard_selector.rb#L54
    def set_shard(shard, &block)
      options = Rails.application.config.active_record.shard_selector

      ActiveRecord::Base.connected_to(shard: shard.to_sym) do
        ActiveRecord::Base.prohibit_shard_swapping(options.fetch(:lock, true), &block)
      end
    end
  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add SidekiqActiveRecordShard::Client
  end
end

Sidekiq.configure_server do |config|
  config.client_middleware do |chain|
    chain.add SidekiqActiveRecordShard::Client
  end
  config.server_middleware do |chain|
    chain.add SidekiqActiveRecordShard::Server
  end
end
