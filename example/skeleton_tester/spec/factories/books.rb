FactoryBot.define do
  factory :book do
    sample_attribute { false }
    
    trait :example_trait do
      sample_attribute { true }
    end

    factory :model_with_trait, traits: [:example_trait]
  end
end
