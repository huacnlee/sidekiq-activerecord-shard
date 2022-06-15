SidekiqActiveRecordShard.configure do
  self.selected_shard = -> do
    case Current.tenant_id
    when "other"
      :other
    else
      :primary
    end
  end
end
