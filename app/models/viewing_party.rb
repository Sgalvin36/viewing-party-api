class ViewingParty < ApplicationRecord
    has_many :party_guests
    has_many :users, through: :party_guests
    
    validates :name, presence: true
    validates :start_time, presence: true
    validates :end_time, presence: true
    validates :movie_id, presence: true
    validates :movie_title, presence: true
    validates :api_key, presence: true
    validates :host, presence: true
end