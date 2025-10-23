FactoryBot.define do
  factory :movie do
    title { "The Matrix" }
    synopsis { "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers." * 2 }
    release_year { 1999 }
    duration { 136 }
    director { "Wachowski Sisters" }
    association :user

    # Filmes com poster
    trait :with_poster do
      after(:build) do |movie|
        movie.poster.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'poster.jpeg')),
          filename: 'poster.jpeg',
          content_type: 'image/jpeg'
        )
      end
    end

    # Filmes com categorias
    trait :with_categories do
      after(:create) do |movie|
        movie.categories << FactoryBot.create(:category)
      end
    end
  end
end
