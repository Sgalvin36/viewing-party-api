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
        binding.pry
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:attributes]).to have_key[:title]
        expect(json[:data][:attributes]).to have_key[:vote_average]
    end
end