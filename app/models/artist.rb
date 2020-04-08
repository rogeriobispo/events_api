class Artist < ApplicationRecord
  acts_as_paranoid
  belongs_to :genre
  validates :name, :member_quantity, :genre_id, :note, presence: true
end
