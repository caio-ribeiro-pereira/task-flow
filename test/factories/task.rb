FactoryBot.define do
  factory :task do
    title { "New Task" }
    description { "This is a new task" }
    status { "pending" }
    priority { "low" }
    completed_at { nil }

    association :user, factory: :user
    association :project, factory: :project

    trait :completed do
      status { "done" }
      completed_at { Time.now }
    end

    trait :in_progress do
      status { "in_progress" }
    end

    trait :pending do
      status { "pending" }
    end

    trait :urgent do
      priority { "high" }
    end

    trait :not_urgent do
      priority { "low" }
    end
  end
end
