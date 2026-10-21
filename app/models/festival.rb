class Festival < ApplicationRecord
  has_many :tickets, dependent: :restrict_with_error
  has_many :stages, dependent: :destroy

  validates :name, presence: true
end
