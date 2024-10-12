FactoryBot.define do
    factory :user do
        name { Faker::Name.name }
        username { Faker::Superhero.name}
        password { Faker::String.random(length: [6, 12])}
    end
end