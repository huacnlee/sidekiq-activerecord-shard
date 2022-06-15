require "test_helper"

class ConfigTest < ActiveSupport::TestCase
  test "config_test" do
    SidekiqActiveRecordShard.configure do
      self.selected_shard = -> {
        return :shard_1
      }
    end

    assert_equal :shard_1, SidekiqActiveRecordShard.config.selected_shard.call
  end
end
