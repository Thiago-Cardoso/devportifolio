FactoryBot.define do
  factory :order do
    status { 1 }
    portfolio { nil }
    moip_id { "MyString" }
    due_date { "2018-10-30" }
  end
end
