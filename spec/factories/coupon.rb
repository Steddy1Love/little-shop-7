FactoryBot.define do
  factory :coupon do
    association :merchant
    name {Faker::Name.initials(number: 3)}
    code {Faker::Code.npi}
    amount_off {Faker::Number.within(range: 5..10000)}
    percent_or_dollar {Faker::Number.within(range: 0..1)}
    status {Faker::Number.within(range: 0..1)}
  end
end