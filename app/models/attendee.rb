class Attendee < ApplicationRecord
  has_many :tickets, dependent: :restrict_with_error

  validates :name, :email, presence: true
end
