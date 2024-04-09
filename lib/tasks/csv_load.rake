require 'csv'

desc "Imports customers data"
task :customers => :environment do    
    CSV.foreach('db/data/customers.csv', :headers => true, header_converters: :symbol) do |row|
      Customers.create!(row.to_hash)
      #do something to reset primary key
    end
end


# to pass arguments to your custom rake task:
# task :task_name, [:arg_1] => [:prerequisite_1, :prerequisite_2] do |task, args|
#   argument_1 = args.arg_1
# end






# require 'csv'
# namespace :import_incidents_csv do
#   task :create_incidents => :environment do
#     "code from the link"  
#   end
# end 
# 



# require 'csv'    

# csv_text = File.read('...')
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#   Moulding.create!(row.to_hash)
# end

