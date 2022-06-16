# Sidekiq Activerecord::Shard Middleware

A Sidekiq middleware for supports ActiveRecord Shard with [ActiveSupport:CurrentAttribute](https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html).

> **Warning** 
> This gem can work with [sidekiq-cron](https://github.com/ondrejbartas/sidekiq-cron) or other schedulers, because when Schedule perform a job, they can't know the which shard to use.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "sidekiq-activerecord-shard"
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
    when "other"
      :other
    else
      :primary
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

### Perform Job by set shared

Some times, you want to perform a job without Request context, or start Job in schedulers.

Now use can use `set(shard: "shard_name")` to set shared in directly.

```rb
# Call job with "other" shard db
MyJob.set(shard: "other").perform_later

# Call job with "primary" shard db
MyJob.set(shard: "primary").perform_later
```

## Contributing

Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
