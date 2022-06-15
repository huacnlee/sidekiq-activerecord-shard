module SidekiqActiveRecordShard
  class Configuration
    attr_accessor :selected_shard
  end

  class << self
    def config
      return @config if defined?(@config)

      @config = Configuration.new
    end

    def configure(&block)
      config.instance_exec(&block)
    end
  end
end
