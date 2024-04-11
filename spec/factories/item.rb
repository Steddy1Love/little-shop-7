FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description {Faker::Lorem.sentence}
    unit_price { Faker::Commerce.price(range: 100..1000) }
    association :merchant
    status {Faker::Number.within(range: 0..1)}
  end
end