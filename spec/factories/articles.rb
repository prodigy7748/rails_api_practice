FactoryBot.define do
  factory :article do
    title { Faker::Lorem.word }
    content { Faker::Lorem.paragraph }
    slug { Faker::Lorem.characters }
  end
end
