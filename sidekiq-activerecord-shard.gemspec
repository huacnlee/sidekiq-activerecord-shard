require_relative "lib/sidekiq-activerecord-shard/version"

Gem::Specification.new do |spec|
  spec.name = "sidekiq-activerecord-shard"
  spec.version = SidekiqActiveRecordShard::VERSION
  spec.authors = ["Jason Lee"]
  spec.email = ["huacnlee@gmail.com"]
  spec.homepage = "https://github.com/huacnlee/sidekiq-activerecord-shard-middleware"
  spec.summary = "Add ActiveRecord Shard supports for Sidekiq."
  spec.description = "A Sidekiq middleware for supports ActiveRecord Shard."
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7"
  spec.add_dependency "sidekiq", ">= 6"
end
