FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    status_message { Faker::Lorem.characters(number: 20) }

    after(:build) do |user|
      user.profile_image.attach(io: File.open("spec/images/no_image_square.jpg"), filename: "no_image_square.jpg", content_type: "image/jpg")
    end
  end
end