FactoryBot.define do
  factory :sub_category do
    name { "MyString" }
    association :category
  end
end
