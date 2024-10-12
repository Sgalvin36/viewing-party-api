require "rails_helper"

RSpec.describe "Users API", type: :request do
  describe "Create User Endpoint" do
    let(:user_params) do
      {
        name: "Me",
        username: "its_me",
        password: "QWERTY123",
        password_confirmation: "QWERTY123"
      }
    end

    context "request is valid" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_users_path, params: user_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(User.last.id.to_s)
        expect(json[:data][:attributes][:name]).to eq(user_params[:name])
        expect(json[:data][:attributes][:username]).to eq(user_params[:username])
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes]).to_not have_key(:password)
        expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
      end
    end

    context "request is invalid" do
      it "returns an error for non-unique username" do
        User.create!(name: "me", username: "its_me", password: "abc123")

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username has already been taken")
        expect(json[:status]).to eq(400)
      end

      it "returns an error when password does not match password confirmation" do
        user_params = {
          name: "me",
          username: "its_me",
          password: "QWERTY123",
          password_confirmation: "QWERT123"
        }

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for missing field" do
        user_params[:username] = ""

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end

  describe "Get All Users Endpoint" do
    it "retrieves all users but does not share any sensitive data" do
      users = create_list(:user, 3)

      get api_v1_users_path

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:attributes]).to have_key(:name)
      expect(json[:data][0][:attributes]).to have_key(:username)
      expect(json[:data][0][:attributes]).to_not have_key(:password)
      expect(json[:data][0][:attributes]).to_not have_key(:password_digest)
      expect(json[:data][0][:attributes]).to_not have_key(:api_key)
    end
  end

  describe "Get One User Endpoint" do
    it "successfully retrieves the correct user" do
        user = create(:user)

        params = {
            "id": user.id
        }

        headers = {
          "CONTENT_TYPE" => "application/json",
          "Authorization" => user.api_key
        }
        get api_v1_user_path(params), headers: headers
        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names:true)
        expect(json[:data][:id].to_i).to eq(user.id)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:attributes][:name]).to eq(user.name)
        expect(json[:data][:attributes][:username]).to eq(user.username)
        expect(json[:data][:attributes][:viewing_parties_hosted]).to eq([])
        expect(json[:data][:attributes][:viewing_parties_invited]).to eq([])
    end

    it "successfully retrieves the correct user and populates the viewing party arrays" do
      user = create(:user)
      users = create_list(:user, 4)
      parties_hosted = create_list(:viewing_party, 3, user_id: user.id, api_key: user.api_key, users: [users[1].id, users[2].id, users[0].id])

      params = {
          "id": user.id
      }

      headers = {
        "CONTENT_TYPE" => "application/json",
        "Authorization" => user.api_key
      }
      get api_v1_user_path(params), headers: headers
      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names:true)
      expect(json[:data][:id].to_i).to eq(user.id)
      expect(json[:data][:type]).to eq("user")
      expect(json[:data][:attributes][:name]).to eq(user.name)
      expect(json[:data][:attributes][:username]).to eq(user.username)
      expect(json[:data][:attributes][:viewing_parties_hosted].length).to eq 3
      expect(json[:data][:attributes][:viewing_parties_invited]).to eq([])

      params = {
          "id": users[0].id
      }

      headers = {
        "CONTENT_TYPE" => "application/json",
        "Authorization" => users[0].api_key
      }
      get api_v1_user_path(params), headers: headers
      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names:true)
      expect(json[:data][:id].to_i).to eq(users[0].id)
      expect(json[:data][:type]).to eq("user")
      expect(json[:data][:attributes][:name]).to eq(users[0].name)
      expect(json[:data][:attributes][:username]).to eq(users[0].username)
      expect(json[:data][:attributes][:viewing_parties_hosted]).to eq([])
      expect(json[:data][:attributes][:viewing_parties_invited].length).to eq(3)
    end

    it "handles different API key and user_id gently" do
      user = User.create(name: "Tom", username: "myspace_creator", password: "test123")
      users = create_list(:user, 4)
      parties_hosted = create_list(:viewing_party, 3, user_id: user.id, api_key: user.api_key, users: [users[2].id, users[1].id, users[0].id])

      params = {
          "id": user.id
      }

      headers = {
        "CONTENT_TYPE" => "application/json",
        "Authorization" => users[0].api_key
      }
      get api_v1_user_path(params), headers: headers
      expect(response).to_not be_successful
      expected = {:message=>"Not the user.", :status=>401}
      json = JSON.parse(response.body, symbolize_names:true)
      expect(json).to eq(expected)
    end

  end
end
