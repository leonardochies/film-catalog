class ImportJob < ApplicationRecord
  belongs_to :user
  has_one_attached :csv_file

  validates :csv_file, presence: true

  enum :status, { pending: "pending", processing: "processing", completed: "completed", failed: "failed" }
end
