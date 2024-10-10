require "rails_helper"

RSpec.describe ViewingParty, type: :model do
    describe "validations" do
        it { should validate_presence_of(:name) }
        it { should validate_presence_of(:start_time) }
        it { should validate_presence_of(:end_time) }
        it { should validate_presence_of(:movie_id) }
        it { should validate_presence_of(:movie_title)}
        it { should validate_presence_of(:api_key) }
        it { should validate_presence_of(:host)}
    end
end