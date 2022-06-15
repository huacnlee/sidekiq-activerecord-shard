SidekiqActiveRecordShard.configure do
  self.selected_shard = -> do
    case Current.tenant_id
    when "company1"
      :company1
    else
      :default
    end
  end
end
