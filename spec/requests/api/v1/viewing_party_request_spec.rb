require "rails_helper"

RSpec.describe "ViewingParty API", type: :request do
    describe "Create ViewingParty Endpoint" do
        it "passes authentication" do
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
                users: [user2.id, user3.id]
            }
            
            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => user.api_key
            }

            post api_v1_viewing_parties_path(params), headers: headers
            # binding.pry
            expect(response).to be_successful
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
                users: [user2.id, user3.id]
            }

            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => user.api_key
            }

            post api_v1_viewing_parties_path(params), headers: headers

            expect(response).to be_successful
            json = JSON.parse(response.body, symbolize_names:true)

            expect(json[:data]).to have_key(:id)
            expect(json[:data][:type]).to eq("viewing_party")
            expect(json[:data][:attributes][:name]).to eq("Friends for ever and ever")
            expect(json[:data][:attributes][:start_time]).to eq("properly formatted start time")
            expect(json[:data][:attributes][:end_time]).to eq("properly formatted end time")
            expect(json[:data][:attributes][:movie_id]).to eq(456)
            expect(json[:data][:attributes][:movie_title]).to eq("Princess Bride")
            expect(json[:data][:relationships][:users][:data].length).to eq 2
        end

        it "returns an error if no provided with an api-key" do
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
                users: [user2.id, user3.id]
            }

            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => ""
            }
            post api_v1_viewing_parties_path(params), headers: headers
            expect(response).to_not be_successful
            expect(response.status).to eq 405
            expected_error = {:message=>"Not logged in.", :status=>405}
            json = JSON.parse(response.body, symbolize_names:true)

            expect(json).to eq(expected_error)
        end

        it "returns an error if not provided with all parameters" do
            user = User.create(name: "Joey", username: "Friend#1", password: "Sitcomking")
            user2 = User.create(name: "Joey", username: "Friend#2", password: "Friendsthebest")
            user3 = User.create(name: "Joey", username: "Friend#3", password: "Onlyfriends")
            params = {
                name: "Friends for ever and ever",
                start_time: "properly formatted start time",
                end_time: "properly formatted end time",
                movie_title: "Princess Bride",
                api_key: user.api_key,
                user_id: user.id,
                users: [user2.id, user3.id]
            }

            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => user.api_key
            }
            post api_v1_viewing_parties_path(params), headers: headers
            expect(response).to_not be_successful
            expect(response.status).to eq 400
            expected_error = {:message=>"Movie can't be blank", :status=>400}
            json = JSON.parse(response.body, symbolize_names:true)

            expect(json).to eq(expected_error)
        end

        xit "returns an error if movie time is longer than party duration" do
            user = User.create(name: "Joey", username: "Friend#1", password: "Sitcomking")
            user2 = User.create(name: "Joey", username: "Friend#2", password: "Friendsthebest")
            user3 = User.create(name: "Joey", username: "Friend#3", password: "Onlyfriends")
            params = {
                name: "Friends for ever and ever",
                start_time: "properly formatted start time",
                end_time: "properly formatted end time",
                movie_title: "Princess Bride",
                api_key: user.api_key,
                user_id: user.id,
                users: [user2.id, user3.id]
            }

            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => user.api_key
            }
            post api_v1_viewing_parties_path(params), headers: headers
            expect(response).to_not be_successful
            expect(response.status).to eq 400
            expected_error = {:message=>"Movie can't be blank", :status=>400}
            json = JSON.parse(response.body, symbolize_names:true)

            expect(json).to eq(expected_error)
        end

        xit "returns an error if end time is before start time" do
            user = User.create(name: "Joey", username: "Friend#1", password: "Sitcomking")
            user2 = User.create(name: "Joey", username: "Friend#2", password: "Friendsthebest")
            user3 = User.create(name: "Joey", username: "Friend#3", password: "Onlyfriends")
            params = {
                name: "Friends for ever and ever",
                start_time: "properly formatted start time",
                end_time: "properly formatted end time",
                movie_title: "Princess Bride",
                api_key: user.api_key,
                user_id: user.id,
                users: [user2.id, user3.id]
            }

            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => user.api_key
            }
            post api_v1_viewing_parties_path(params), headers: headers
            expect(response).to_not be_successful
            expect(response.status).to eq 400
            expected_error = {:message=>"Movie can't be blank", :status=>400}
            json = JSON.parse(response.body, symbolize_names:true)

            expect(json).to eq(expected_error)
        end

        it "handles if an invalid guest id is provided" do
            user = User.create(name: "Joey", username: "Friend#1", password: "Sitcomking")
            user2 = User.create(name: "Joey", username: "Friend#2", password: "Friendsthebest")
            user3 = User.create(name: "Joey", username: "Friend#3", password: "Onlyfriends")
            params = {
                name: "Friends for ever and ever",
                start_time: "properly formatted start time",
                end_time: "properly formatted end time",
                movie_title: "Princess Bride",
                movie_id: 12,
                api_key: user.api_key,
                user_id: user.id,
                users: [5, user2.id, user3.id, 0]
            }

            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => user.api_key
            }
            post api_v1_viewing_parties_path(params), headers: headers
            expect(response).to be_successful
            expect(response.status).to eq 201

            json = JSON.parse(response.body, symbolize_names:true)

            expect(json[:data][:relationships][:users][:data].length).to eq 2
            expect(json[:data][:relationships][:users][:data][0][:id].to_i).to eq(user2.id) 
            expect(json[:data][:relationships][:users][:data][1][:id].to_i).to eq(user3.id)
        end
    end
end