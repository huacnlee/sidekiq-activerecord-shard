class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  connects_to shards: {
    primary: {writing: :primary, reading: :primary},
    other: {writing: :other, reading: :other}
  }
end
