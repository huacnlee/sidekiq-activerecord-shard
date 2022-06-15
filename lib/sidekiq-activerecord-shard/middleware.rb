require "sidekiq"

module SidekiqActiveRecordShard
  class Client
    include ::Sidekiq::ClientMiddleware

    def call(_jobclass, job, _queue, _redis)
      job["_active_record_shared"] ||= SidekiqActiveRecordShard.selected_shard.call
      yield
    end
  end

  class Server
    include Sidekiq::ServerMiddleware
    def call(_jobclass, job, _queue, &block)
      set_shard(job["_active_record_shared"], &block)
    end

    def set_shard(shared, &block)
      ActiveRecord::Base.connected_to(shard: shard.to_sym) do
        ActiveRecord::Base.prohibit_shard_swapping(true, &block)
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
