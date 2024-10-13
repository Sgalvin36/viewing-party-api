require "rails_helper"

RSpec.describe ViewingParty, type: :model do
    describe "validations" do
        it { should validate_presence_of(:name) }
        it { should validate_presence_of(:start_time) }
        it { should validate_presence_of(:movie_id) }
        it { should validate_presence_of(:movie_title)}
        it { should validate_presence_of(:api_key) }
        it { should validate_presence_of(:user_id)}
    end

    describe "relationships" do
        it { should belong_to(:host)}
        it { should have_many(:party_guests)}
        it { should have_many(:users).through(:party_guests)}
    end

    describe "#users" do
        it "creates a PartyGuest entry for each item in array" do
            user = User.create(name: "Joey", username: "Friend#3", password: "Onlyfriends")
            user1 = User.create(name: "Joey", username: "Friend#1", password: "Sitcomking")
            user2 = User.create(name: "Joey", username: "Friend#2", password: "Friendsthebest")
            params = {
                name: "Friends for ever and ever",
                start_time: 2.hours.from_now,
                end_time: 4.hours.from_now,
                movie_id: 2493,
                movie_title: "Princess Bride",
                api_key: user.api_key,
                user_id: user.id,
            }
            id_array = [user1.id, user2.id]
            party = ViewingParty.create(params)
            party.users = id_array 

            expect(PartyGuest.count).to eq(2)
            expect(party.users).to include(user1, user2)
        end

        it 'handles being unable to save the party gently' do
            viewing_party = ViewingParty.new
            allow(viewing_party).to receive(:save).and_return(false)
            viewing_party.users = [2,3,5]

            expect(viewing_party.errors[:base]).to eq(["Party could not be saved"])
        end

        it "handles party validation gently" do
            json_data = {
            "id"=> "345",
            "title"=> "The Best movie EVER",
            "release_date"=> "2012-10-10",
            "vote_average"=> 9.99,
            "runtime"=> 921,
            "genres"=> [{"name"=> "mystery"}, {"name"=> "comedy"}],
            "overview"=> "One of the finest movies ever made, but no one has every heard of",
            "credits" =>{
                "cast"=> [
                    {"actor"=> "Steven Forest", "character"=> "Stone-Cold Austin"},
                    {"actor"=> "Clementine Jones", "character"=> "Mrs. Frazzle"},
                    {"actor"=> "Courtney Country", "character"=> "Cadaver #1"}
                ]},
            "reviews"=> {
                "totals_results"=> 829,
                "results"=> [
                    {"author"=> "Sir Author the auther", "content"=> "Bloody magnificent"},
                    {"author"=> "Bob", "content"=> "Was alright"},
                    {"author"=> "Mom with a claws", "content"=> "Not enough cats"},
                    {"author"=> "Joseph", "content"=> "I thought this was Batman, where is Batman?"}
                ]
            }}
            
            allow(MovieDbService).to receive(:fetch_data).and_return(
                double(status: 200, body: json_data.to_json)
            )
            party = ViewingParty.new({
                name: "Friends for ever and ever",
                start_time: 2.hours.from_now,
                end_time: 1.hour.from_now,
                movie_title: "Princess Bride",
                movie_id: 12,
                api_key: "test_api_key",
                user_id: 1,
                users: [2, 3]
            })

            expect(party.save).to be_falsey
            expect(party.errors[:end_time]).to include("cannot be before the start time")

            party = ViewingParty.new({
                name: "Friends for ever and ever",
                start_time: 1.hours.from_now,
                end_time: 2.hour.from_now,
                movie_title: "Princess Bride",
                movie_id: 12,
                api_key: "test_api_key",
                user_id: 1,
                users: [2, 3]
            })

            expect(party.save).to be_falsey
            expect(party.errors[:end_time]).to include("cannot be less then length of movie")
        end
    end
end