FactoryGirl.define do

  factory :user do

    factory :admin do
      first_name "Admin"
      last_name "Istrator"
      email "admin@mail.com"
      is_student false
    end

    factory :instructor do
      first_name "Keith"
      last_name "Conroy"
      email "keith@mail.com"
      is_student false
    end

    factory :other_instructor do
      first_name "Keith"
      last_name "Conroy"
      email "other_keith@mail.com"
      is_student false
    end

    factory :student do
      first_name "Test"
      last_name "Student"
      email "student@mail.com"
      is_student true
    end

    factory :student2 do
      first_name "Test"
      last_name "Student2"
      email "student2@mail.com"
      is_student true
    end

    factory :other_student do
      first_name "Test"
      last_name "Student"
      email "other_student@mail.com"
      is_student true
    end

    password "12345678"
    organization
  end

end