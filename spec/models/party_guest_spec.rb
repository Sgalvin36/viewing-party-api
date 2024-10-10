require "rails_helper"

RSpec.describe PartyGuest, type: :model do
    describe "validations" do
        it { should validate_presence_of(:user_id) }
        it { should validate_presence_of(:viewing_party_id) }
    end
end