class User < ApplicationRecord
  has_many :party_guests
  has_many :attended_parties, through: :party_guests, source: :viewing_party
  has_many :hosted_parties, class_name: "ViewingParty", foreign_key: "user_id"
  
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
  has_secure_token :api_key

end