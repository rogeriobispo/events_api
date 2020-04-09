class Event < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :artists
  has_many :genres
  has_many :genres, through: :artists
  validates :kind, :occurred_on, :location,
            :line_up_date, :artists,
            :time_zone, presence: true
  enum kind: { festival: 'festival', concert: 'concert' }
end
