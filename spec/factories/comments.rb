FactoryBot.define do
  factory :comment do
    content { "Baita filme :)" }
    association :movie
    association :user

    # Comentário anônimo
    trait :anonymous do
      user { nil }
      author_name { "Anonymous User" }
    end
  end
end
