class TenantShard
  class << self
    def shard_resolver(request)
      shard_resolver_by_id(request.headers["x-tenant-id"])
    end

    def shard_resolver_by_id(tenant_id)
      case tenant_id
      when "company1"
        :company1
      else
        :default
      end
    end
  end
end
