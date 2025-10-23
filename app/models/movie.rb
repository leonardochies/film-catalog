class Movie < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :poster
  has_and_belongs_to_many :categories

  validates :user, presence: true
  validates :title, presence: true
  validates :synopsis, presence: true, length: { minimum: 50, maximum: 800   }
  validates :release_year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1888 }, length: { is: 4 }
  validates :duration, presence: true
  validates :director, presence: true

  # Busca que funciona com texto e número (digitar diretor e ano de lançamento na mesma consulta)
  scope :smart_search, ->(term) {
    return all if term.blank?

    years = term.scan(/\b\d{4}\b/).map(&:to_i)
    text_without_year = term.gsub(/\b\d{4}\b/, "").strip

    if years.any? && text_without_year.present?
      where("(title ILIKE ? OR director ILIKE ?) AND release_year IN (?)",
            "%#{text_without_year}%", "%#{text_without_year}%", years)
    elsif years.any?
      where(release_year: years)
    else
      where("title ILIKE ? OR director ILIKE ?", "%#{term}%", "%#{term}%")
    end
  }

  def self.ransackable_attributes(auth_object = nil)
    [ "director", "release_year", "title" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "categories", "user" ]
  end
end
