require "rails_helper"

RSpec.describe "ViewingParty API", type: :request do
    describe "Create ViewingParty Endpoint" do
        it "passes authentication" do
            
        end

        it "can create a viewing party" do
            user = User.create(name: "Joey", username: "Friend#1", password: "Sitcomking")
            user2 = User.create(name: "Joey", username: "Friend#2", password: "Friendsthebest")
            user3 = User.create(name: "Joey", username: "Friend#3", password: "Onlyfriends")
            params = {
                name: "Friends for ever and ever",
                start_time: "properly formatted start time",
                end_time: "properly formatted end time",
                movie_id: 456,
                movie_title: "Princess Bride",
                api_key: user.api_key,
                user_id: user.id,
                "users": [user2.id, user3.id]
            }

            post api_v1_viewing_parties_path(params)

            expect(response).to be_successful
            json = JSON.parse(response.body, symbolize_names:true)
            binding.pry
            expect(json[:data]).to have_key(:id)
            expect(json[:data][:type]).to eq("viewing_party")
            expect(json[:data][:attributes][:name]).to eq("Friends for ever and ever")
            expect(json[:data][:attributes][:start_time]).to eq("properly formatted start time")
            expect(json[:data][:attributes][:end_time]).to eq("properly formatted end time")
            expect(json[:data][:attributes][:movie_id]).to eq(456)
            expect(json[:data][:attributes][:movie_title]).to eq("Princess Bride")
        end

        it "populates the viewing party appropriately" do
        end
    end
end