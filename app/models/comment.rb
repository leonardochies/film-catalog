class Comment < ApplicationRecord
  belongs_to :movie
  belongs_to :user, optional: true

  validates :content,
    presence: { message: I18n.t("comments.errors.content_blank") },
    length: { maximum: 400, message: I18n.t("comments.errors.content_too_long") }

  validates :author_name,
    presence: {
      if: :anonymous?,
      message: I18n.t("comments.errors.author_name_blank")
    },
    length: {
      maximum: 16,
      message: I18n.t("comments.errors.author_name_too_long")
    },
    format: {
      with: /\A[a-zA-Z\s]+\z/,
      message: I18n.t("comments.errors.invalid_author_name"),
      if: :anonymous?
    }

  private

  def anonymous?
    user.nil?
  end
end
