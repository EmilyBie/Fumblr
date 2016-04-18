require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'blogdb'
}

ActiveRecord::Base.establish_connection(options)