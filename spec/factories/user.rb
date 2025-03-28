FactoryBot.difine do
  factory :user do
    name { Faker::Name.name(number:6) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length:6) }
    password_confirmation { password }
  end
end