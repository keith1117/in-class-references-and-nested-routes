class Track < ApplicationRecord
  belongs_to :artist
  validates :title, presence: true
  validates :length_sec, numericality: { greater_than: 0 }
end
