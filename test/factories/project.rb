FactoryBot.define do
  factory :project do
    name { "New Project" }
    description { "This is a new project" }
    status { "active" }

    association :user, factory: :user

    trait :archived do
      status { "archived" }
    end
  end
end
