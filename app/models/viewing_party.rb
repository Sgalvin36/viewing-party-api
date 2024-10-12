class ViewingParty < ApplicationRecord
    has_many :party_guests
    has_many :users, through: :party_guests
    belongs_to :host, class_name: "User", foreign_key: "user_id"
    
    validates :name, presence: true
    validates :start_time, presence: true
    validates :end_time, presence: true
    validates :movie_id, presence: true
    validates :movie_title, presence: true
    validates :api_key, presence: true
    validates :user_id, presence: true

    def users=(invitees_array)
        if self.save
            invitees_array.each do |invitee|
                invited = User.find_by(id: invitee.to_i)
                if invited.present?
                    self.party_guests.create(user: invited)
                end
            end
        else
            errors.add(:base, "Party could not be saved: #{self.errors.full_messages.to_sentence}")
        end
    end
end