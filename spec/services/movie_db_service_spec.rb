require "rails_helper"

RSpec.describe MovieDbService do
    describe ".connection" do
        it "makes a connection" do
            connection = MovieDbService.connection

            expect(connection).to be_a(Faraday::Connection)
            expect(connection.url_prefix.to_s).to eq("https://api.themoviedb.org/3/")
            expect(connection.headers["Authorization"]).to include("Bearer")
        end
    end

    describe ".fetch_data" do
        it "gets a response" do
            response = MovieDbService.fetch_data("movie/top_rated")

            expect(response).to be_a(Faraday::Response)
            expect(response.status).to eq 200
        end
    end
end