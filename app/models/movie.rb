class Movie < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :user, presence: true
  validates :title, presence: true
  validates :synopsis, presence: true
  validates :release_year, presence: true
  validates :duration, presence: true
  validates :director, presence: true
end
