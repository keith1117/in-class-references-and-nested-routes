class Stage < ApplicationRecord
  belongs_to :festival
  
  has_many :performances, dependent: :destroy
  has_many :artists, through: :performances

  validates :name, presence: true
  validates :capacity, numericality: { greater_than: 0 }, allow_nil: true
end
