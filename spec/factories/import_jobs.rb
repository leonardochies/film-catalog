FactoryBot.define do
  factory :import_job do
    association :user
    status { "pending" }
    error_message { nil }

    after(:build) do |import_job|
      import_job.csv_file.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'movies.csv')),
        filename: 'movies.csv',
        content_type: 'text/csv'
      )
    end
  end
end
