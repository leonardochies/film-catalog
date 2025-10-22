class Movie < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :poster
  has_and_belongs_to_many :categories

  validates :user, presence: true
  validates :title, presence: true
  validates :synopsis, presence: true, length: { minimum: 50, maximum: 800   }
  validates :release_year, presence: true
  validates :duration, presence: true
  validates :director, presence: true
end
