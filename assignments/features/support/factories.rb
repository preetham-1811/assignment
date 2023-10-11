FactoryBot.define do

  factory :admin, class: User do
    email { 'admin@ait' }
    password { 'password' }
    password_confirmation { 'password' }
    is_admin? { true }
    is_professor? { false }
    is_user? { false }
    uid { "ad000001" }
    first_name { "The" }
    middle_name { "AIT" }
    last_name { "Admin" }
    confirmed_at { 1.day.ago }
  end

  factory :user, class: User do
    sequence(:email) { |n| "user#{n}@ait" }
    password { 'password' }
    password_confirmation { 'password' }
    is_admin? { false }
    is_professor? { false }
    is_user? { true }
    sequence (:uid) { |n| "st#{111111 + n}" }
    sequence (:first_name) { |n| "John #{n}"}
    sequence (:middle_name) { |n| "Wick #{n}"}
    sequence (:last_name) { |n| "Winkle #{n}"}
    created_at { time_rand from = 5.years.ago }
    confirmed_at { 1.day.ago }
  end

end

def time_rand(from = 0.0, to = Time.now)
  Time.at(from + rand * (to.to_f - from.to_f))
end
