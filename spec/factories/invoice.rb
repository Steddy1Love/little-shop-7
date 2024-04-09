FactoryBot.define do
  factory :invoice do
    association :customer 
    status {Faker::Number.within(range: 0..2)} 
  end
end