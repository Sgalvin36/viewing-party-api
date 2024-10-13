class ViewingParty < ApplicationRecord
    has_many :party_guests
    has_many :users, through: :party_guests
    belongs_to :host, class_name: "User", foreign_key: "user_id"
    
    validates :name, presence: true
    validates :start_time, presence: true
    validates :movie_id, presence: true
    validates :movie_title, presence: true
    validates :api_key, presence: true
    validates :user_id, presence: true

    validate :validate_party_duration

    def validate_party_duration
        external_response = MovieDbService.fetch_data("movie/#{self.movie_id}?append_to_response=reviews,credits")
        if external_response.status == 200
            movie = Movie.new(JSON.parse(external_response.body)) 
            duration = (end_time.to_time - start_time.to_time) / 60
            if end_time.present? && start_time.present? && end_time.to_time < start_time.to_time
                errors.add(:end_time, "cannot be before the start time")
            elsif duration < movie.duration
                errors.add(:end_time, "cannot be less then length of movie")
            end
        end
    end

    def users=(invitees_array)
        if self.save
            invitees_array.each do |invitee|
                invite = User.find_by(id: invitee.to_i)
                invited = self.party_guests.find_by(user_id: invitee.to_i)
                if invite.present? && !invited.present?
                    self.party_guests.create(user: invite)
                end
            end
        else
            errors.add(:base, "Party could not be saved")
        end
    end
end