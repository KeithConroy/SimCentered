FactoryGirl.define do
  factory :organization do
    title "University"
    subdomain "uni"
  end

  factory :user do
    first_name "Admin"
    last_name "Istrator"
    email "admin@mail.com"
    is_student false
    password "12345678"

    organization
  end

end