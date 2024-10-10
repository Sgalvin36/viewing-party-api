require "rails_helper"

RSpec.describe "Movies API", type: :request do
    it "Connect to external API" do
        VCR.use_cassette("top_20_movie_search") do
            get api_v1_movies_path

            expect(response).to be_successful
        end
    end

    it "Returns a JSON of formatted data", :vcr do
        VCR.use_cassette("top_20_movie_search") do
            get api_v1_movies_path

            expect(response).to be_successful

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

    it "can search for movie titles", :vcr do
        params = { "query": "Star Wars"}
        get api_v1_movies_path(params)
        
        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)

        json[:data].each do |movie|
            expect(movie).to have_key(:id)
            expect(movie[:type]).to eq "movie"
            expect(movie[:attributes]).to have_key(:title)
            expect(movie[:attributes][:title]).to include(params[:query])
            expect(movie[:attributes]).to have_key(:vote_average)
        end
    end

    it "returns detailed results for a single movie, by id", :vcr do
        params = { id: 140607 }

        get api_v1_movie_path(params[:id])

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names:true)

        expect(json[:data][:id]).to eq "140607"
        expect(json[:data][:type]).to eq "movie"
        expect(json[:data][:attributes][:title]).to eq "Star Wars: The Force Awakens"
        expect(json[:data][:attributes][:release_year]).to eq "2015"
        expect(json[:data][:attributes][:vote_average]).to eq 7.274
        expect(json[:data][:attributes][:runtime]).to eq "2 hours, 16 minutes"
        expect(json[:data][:attributes][:genres]).to eq ["Adventure", "Action", "Science Fiction"]
        expect(json[:data][:attributes][:cast].length).to eq 10
        expect(json[:data][:attributes][:total_reviews]).to eq 8
        expect(json[:data][:attributes][:reviews].length).to eq 5
    end
end