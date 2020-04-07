class Event < ApplicationRecord
  belongs_to :user
  has_many :genres, through: :event_genres
end
