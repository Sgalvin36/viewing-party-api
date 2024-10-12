require "rails_helper"

RSpec.describe ViewingParty, type: :model do
    describe "validations" do
        it { should validate_presence_of(:name) }
        it { should validate_presence_of(:start_time) }
        it { should validate_presence_of(:end_time) }
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
                start_time: "properly formatted start time",
                end_time: "properly formatted end time",
                movie_id: 456,
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
    end
end