FactoryBot.define do
  factory :invoice_item do
    association :item
    association :invoice
    quantity {Faker::Number.within(range: 1..20)}
    unit_price {Faker::Number.within(range: 1000..100000)}
    status {Faker::Number.within(range: 0..2)}
  end
end