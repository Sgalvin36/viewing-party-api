FactoryBot.define do
    factory :viewing_party do
        name { Faker::Superhero.name }
        start_time { Time.now }
        end_time { (Time.now + 4.hours) }
        movie_id { Faker::Number.number(digits: 6)}
        movie_title { Faker::Movie.title}
        api_key { 'invalid_key'}
        user_id { 42 }
        users { [3, 4, 5]}
    end
end