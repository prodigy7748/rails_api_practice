FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "#{Faker::Name.name} #{n}" }
    name { Faker::Name.name }
    url { Faker::Internet.url }
    avatar_url { Faker::Internet.url }
    provider { "github" }
  end
end
