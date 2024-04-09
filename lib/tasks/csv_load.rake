require 'csv'


namespace :csv_load do
  desc "Imports customers data"
  task :customers => :environment do    
      CSV.foreach('db/data/customers.csv', :headers => true) do |row|
        Customer.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!('customers')
    end
  
  desc "Imports invoice_items data"
  task :invoice_items => :environment do    
      CSV.foreach('db/data/invoice_items.csv', :headers => true) do |row|
        InvoiceItem.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
    end

  desc "Imports invoices data"
  task :invoices => :environment do    
      CSV.foreach('db/data/invoices.csv', :headers => true) do |row|
        Invoice.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
    end

  desc "Imports items data"
  task :items => :environment do    
      CSV.foreach('db/data/items.csv', :headers => true) do |row|
        Item.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!('items')
    end

  desc "Imports merchants data"
  task :merchants => :environment do    
      CSV.foreach('db/data/merchants.csv', :headers => true) do |row|
        Merchant.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
    end

  desc "Imports transactions data"
  task :transactions => :environment do    
      CSV.foreach('db/data/transactions.csv', :headers => true) do |row|
        Transaction.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
    end

  # desc "Imports customers data"
  # task :invoice_items => :environment do    
  #     CSV.foreach('db/data/invoice_items.csv', :headers => true) do |row|
  #       Customers.create!(row.to_hash)
  #     end
  #     ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  #   end

    task :all => [:merchants,:invoices, :items, :invoice_items,  :customers,  :transactions]


  end
