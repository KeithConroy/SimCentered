FactoryGirl.define do
  factory :organization do
    title "University"
    subdomain "uni"
  end
  factory :instructor, class: User do
    first_name "Keith"
    last_name "Conroy"
    email "keith@mail.com"
    organization
    is_student false
  end
  factory :course do
    title "Test Course"
    instructor
    organization
  end
end