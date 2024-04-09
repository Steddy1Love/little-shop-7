require 'csv'

namespace :csv_load do
desc "Imports customers data"
task :customers => :environment do    
    CSV.foreach('db/data/customers.csv', :headers => true) do |row|
      Customers.create!(row.to_hash)
      #do something to reset primary key
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
  end
end