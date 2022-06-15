require "test_helper"

class ConfigTest < ActiveSupport::TestCase
  test "config_test" do
    assert_equal :primary, SidekiqActiveRecordShard.config.selected_shard.call
  end
end
