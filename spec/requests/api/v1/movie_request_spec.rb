require "rails_helper"

RSpec.describe "Movies API", type: :request do
    it "Connect to external API" do
        params = { api_key: Rails.application.credentials.the_movie_db[:key]}
        get api_v1_movies_path(params)

        expect(response).to be_successful
    end

    it "Returns a JSON of formatted data" do
        params = { api_key: Rails.application.credentials.the_movie_db[:key]}
        get api_v1_movies_path(params)

        expect(response).to be_successful
        # binding.pry
        json = JSON.parse(response.body, symbolize_names: true)

        json[:data].each do |movie|
            expect(movie).to have_key(:id)
            expect(movie[:type]).to eq "movie"
            expect(movie[:attributes]).to have_key(:title)
            expect(movie[:attributes]).to have_key(:vote_average)
        end
        expect(json[:data].length).to eq 20
    end
end