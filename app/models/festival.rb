class Festival < ApplicationRecord
  has_many :stages, dependent: :destroy

  validates :name, presence: true
end
