require "rails_helper"

RSpec.describe "ViewingParty API", type: :request do
    describe "Create ViewingParty Endpoint" do
        it "passes authentication" do
            users = create_list(:user, 3)
            params = {
                name: "Friends for ever and ever",
                start_time: "properly formatted start time",
                end_time: "properly formatted end time",
                movie_id: 456,
                movie_title: "Princess Bride",
                api_key: users[0].api_key,
                user_id: users[0].id,
                users: [users[1].id, users[2].id]
            }

            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => users[0].api_key
            }
            post api_v1_viewing_parties_path(params), headers: headers
            expect(response).to be_successful
        end

        it "can create a viewing party" do
            users = create_list(:user, 3)
            params = {
                name: "Friends for ever and ever",
                start_time: "properly formatted start time",
                end_time: "properly formatted end time",
                movie_id: 456,
                movie_title: "Princess Bride",
                api_key: users[0].api_key,
                user_id: users[0].id,
                users: [users[1].id, users[2].id]
            }

            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => users[0].api_key
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
            users = create_list(:user, 3)
            params = {
                name: "Friends for ever and ever",
                start_time: "properly formatted start time",
                end_time: "properly formatted end time",
                movie_id: 456,
                movie_title: "Princess Bride",
                api_key: users[0].api_key,
                user_id: users[0].id,
                users: [users[1].id, users[2].id]
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
            users = create_list(:user, 3)
            params = {
                name: "Friends for ever and ever",
                start_time: "properly formatted start time",
                end_time: "properly formatted end time",
                movie_title: "Princess Bride",
                api_key: users[0].api_key,
                user_id: users[0].id,
                users: [users[1].id, users[2].id]
            }

            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => users[0].api_key
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
                start_time: Time.now,
                end_time: (Time.now + 2.hours),
                movie_title: "Princess Bride",
                movie_id: 12,
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
            expected_error = {:message=>"End time must be after start time", :status=>400}
            json = JSON.parse(response.body, symbolize_names:true)

            expect(json).to eq(expected_error)
        end

        it "handles if an invalid guest id is provided" do
            users = create_list(:user, 3)
            params = {
                name: "Friends for ever and ever",
                start_time: "properly formatted start time",
                end_time: "properly formatted end time",
                movie_id: 456,
                movie_title: "Princess Bride",
                api_key: users[0].api_key,
                user_id: users[0].id,
                users: [5, users[1].id, users[2].id, 0]
            }

            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => users[0].api_key
            }
            post api_v1_viewing_parties_path(params), headers: headers
            expect(response).to be_successful
            expect(response.status).to eq 201

            json = JSON.parse(response.body, symbolize_names:true)

            expect(json[:data][:relationships][:users][:data].length).to eq 2
            expect(json[:data][:relationships][:users][:data][0][:id].to_i).to eq(users[1].id) 
            expect(json[:data][:relationships][:users][:data][1][:id].to_i).to eq(users[2].id)
        end
    end

    describe "Update ViewingParty Endpoint" do
        it "can add users to existing party" do
            users = create_list(:user, 5)
            params = {
                name: "Friends for ever and ever",
                start_time: Time.now,
                end_time: (Time.now + 4.hours),
                movie_id: 456,
                movie_title: "Princess Bride",
                api_key: users[0].api_key,
                user_id: users[0].id,
                users: [users[2].id, users[1].id]
            }

            party = ViewingParty.new(params)

            params = {
                "id": party.id,
                "users": [users[3].id, users[4].id]
            }
            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => users[0].api_key
            }
            put api_v1_viewing_party_path(params), headers: headers

            expect(response).to be_successful
            json = JSON.parse(response.body, symbolize_names:true)

            expect(json[:data][:relationships][:users][:data].length).to eq 4
            expect(json[:data][:relationships][:users][:data][0][:id].to_i).to eq(users[1].id) 
            expect(json[:data][:relationships][:users][:data][1][:id].to_i).to eq(users[2].id)
            expect(json[:data][:relationships][:users][:data][2][:id].to_i).to eq(users[3].id)
            expect(json[:data][:relationships][:users][:data][3][:id].to_i).to eq(users[4].id)
        end
    
        it "handles an invalid viewing party gently" do
            user = User.create(name: "Joey", username: "Friend#1", password: "Sitcomking")
            user2 = User.create(name: "Joey", username: "Friend#2", password: "Friendsthebest")
            params = {
                "id": 223509132460,
                "users": [user2.id]
            }
            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => user.api_key
            }
            put api_v1_viewing_party_path(params), headers: headers

            expect(response).to_not be_successful
            expected = {:message=>"Viewing party not found", :status=>404}

            json = JSON.parse(response.body, symbolize_names:true)
            expect(json).to eq(expected)
        end

        it "handles a missing API key correctly" do
            user = User.create(name: "Joey", username: "Friend#1", password: "Sitcomking")
            user2 = User.create(name: "Joey", username: "Friend#2", password: "Friendsthebest")
            user3 = User.create(name: "Joey", username: "Friend#3", password: "Onlyfriends")
            user4 = User.create(name: "Jacob", username: "Thing1", password: "SuessforDays")
            user5 = User.create(name: "John", username: "Thing2", password: "RedFishBlueFish")
            params = {
                name: "Friends for ever and ever",
                start_time: Time.now,
                end_time: (Time.now + 4.hours),
                movie_id: 456,
                movie_title: "Princess Bride",
                api_key: user.api_key,
                user_id: user.id,
                users: [user2.id, user3.id]
            }

            party = ViewingParty.new(params)

            params = {
                "id": party.id,
                "users": [user4.id, user5.id]
            }
            headers = { 
                "CONTENT_TYPE" => "application/json",
            }
            put api_v1_viewing_party_path(params), headers: headers
        
            expected = {:message=>"Not logged in.", :status=>405}
            expect(response).to_not be_successful
            
            json = JSON.parse(response.body, symbolize_names:true)
            expect(json).to eq(expected)
        end

        it "handles a missing API key correctly" do
            user = User.create(name: "Joey", username: "Friend#1", password: "Sitcomking")
            user2 = User.create(name: "Joey", username: "Friend#2", password: "Friendsthebest")
            user3 = User.create(name: "Joey", username: "Friend#3", password: "Onlyfriends")
            user4 = User.create(name: "Jacob", username: "Thing1", password: "SuessforDays")
            user5 = User.create(name: "John", username: "Thing2", password: "RedFishBlueFish")
            params = {
                name: "Friends for ever and ever",
                start_time: Time.now,
                end_time: (Time.now + 4.hours),
                movie_id: 456,
                movie_title: "Princess Bride",
                api_key: user2.api_key,
                user_id: user2.id,
                users: [user.id, user3.id]
            }

            party = ViewingParty.new(params)

            params = {
                "id": party.id,
                "users": [user4.id, user5.id]
            }
            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => user.api_key
            }
            put api_v1_viewing_party_path(params), headers: headers
        
            expected = {:message=>"Not the host.", :status=>401}
            expect(response).to_not be_successful
            
            json = JSON.parse(response.body, symbolize_names:true)
            expect(json).to eq(expected)
        end

        it "handles an invalid user ID correctly" do
            user = User.create(name: "Joey", username: "Friend#1", password: "Sitcomking")
            user2 = User.create(name: "Joey", username: "Friend#2", password: "Friendsthebest")
            user3 = User.create(name: "Joey", username: "Friend#3", password: "Onlyfriends")
            user4 = User.create(name: "Jacob", username: "Thing1", password: "SuessforDays")
            user5 = User.create(name: "John", username: "Thing2", password: "RedFishBlueFish")
            params = {
                name: "Friends for ever and ever",
                start_time: Time.now,
                end_time: (Time.now + 4.hours),
                movie_id: 456,
                movie_title: "Princess Bride",
                api_key: user.api_key,
                user_id: user.id,
                users: [user2.id, user3.id]
            }

            party = ViewingParty.new(params)

            params = {
                "id": party.id,
                "users": [user4.id, user5.id, 102331, user2.id, 4123120]
            }
            headers = { 
                "CONTENT_TYPE" => "application/json",
                "Authorization" => user.api_key
            }
            put api_v1_viewing_party_path(params), headers: headers
            expect(response).to be_successful

            json = JSON.parse(response.body, symbolize_names:true)
            data = json[:data][:relationships][:users][:data]
            expect(data.length).to eq 4
            expect(data[0][:id].to_i).to eq(user2.id) 
            expect(data[1][:id].to_i).to eq(user3.id)
            expect(data[2][:id].to_i).to eq(user4.id)
            expect(data[3][:id].to_i).to eq(user5.id)
        end
    end
end