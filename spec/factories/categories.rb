FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "category_#{n}" }

    # Factories nomeadas para categorias específicas
    factory :action_category do
      name { "action" }
    end

    factory :scifi_category do
      name { "sci_fi" }
    end

    factory :drama_category do
      name { "drama" }
    end
  end
end
