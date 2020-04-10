class Event < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_and_belongs_to_many :artists
  has_many :genres
  has_many :genres, through: :artists
  validates :kind, :occurred_on, :location,
            :line_up_date, :artists,
            :time_zone, presence: true
  enum kind: { festival: 'festival', concert: 'concert' }


  scope :by_user_time_zone, ->(time_zone) { where(time_zone: time_zone) if time_zone.present? }
  scope :filter_genre, ->(filter) { select{ |evt| evt.genres.pluck(:name).include?(filter) if filter.present? }}

end
