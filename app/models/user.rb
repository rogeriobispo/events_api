class User < ApplicationRecord
  acts_as_paranoid
  has_secure_password
  has_many :events
  validates :name, :email, :password,
            :password_confirmation, :time_zone, presence: true
end
