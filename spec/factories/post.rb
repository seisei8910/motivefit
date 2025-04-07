FactoryBot.define do
  factory :post do
    start_time { DateTime.now }
    title { Faker::Lorem.characters(number:5) }
    menu { Faker::Lorem.characters(number:10) }
    body { Faker::Lorem.characters(number:20) }
    association :user

    after(:build) do |post|
      post.image.attach(io: File.open('spec/images/no_image_square.jpg'), filename: 'no_image_square.jpg', content_type: 'image/jpg')
    end
  end
end