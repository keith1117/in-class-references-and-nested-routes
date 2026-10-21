class Stage < ApplicationRecord
  belongs_to :festival

  validates :name, presence: true
  validates :capacity, numericality: { greater_than: 0 }, allow_nil: true
end
