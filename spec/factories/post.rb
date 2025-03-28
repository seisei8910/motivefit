FactoryBot.define do
  factory :post do
    start_time { DateTime.now }
    title { Faker::Lorem.characters(number:5) }
    menu { Faker::Lorem.characters(number:10) }
    body { Faker::Lorem.characters(number:20) }
    association :user
  end
end