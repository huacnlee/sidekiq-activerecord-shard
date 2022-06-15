# Sidekiq Activerecord::Shard Middleware

A Sidekiq middleware for supports ActiveRecord Shard with [ActiveSupport:CurrentAttribute](https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "https://github.com/huacnlee/sidekiq-activerecord-shard"
```

And then execute:
```bash
$ bundle
```

## Usage

Add follow code into `config/initializers/sidekiq-activerecord-shard.rb`:

```rb
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
```

Create `app/models/current.rb`:

```rb
class Current < ActiveSupport::CurrentAttributes
  attribute :tenant_id
end
```

Set `Current.tenant_id` on ApplicationController:

```rb
class ApplicationController < ActionController::Base
  before_action :set_current_tenant_id

  def set_current_tenant_id
    Current.tenant_id = request.headers["x-tenant-id"]
  end
end
```

## Contributing

Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
