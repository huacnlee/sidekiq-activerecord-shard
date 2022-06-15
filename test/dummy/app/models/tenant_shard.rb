class TenantShard
  class << self
    def shard_resolver(request)
      shard_resolver_by_id(request.headers["x-tenant-id"])
    end

    def shard_resolver_by_id(tenant_id)
      case tenant_id
      when "other"
        :other
      else
        :primary
      end
    end
  end
end
