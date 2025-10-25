FactoryBot.define do
  factory :import_job do
    user { nil }
    status { "MyString" }
    error_message { "MyText" }
  end
end
