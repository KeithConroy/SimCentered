FactoryGirl.define do

  factory :event do
    title "Test Event"
    start DateTime.now
    finish DateTime.now + 60.minutes

    instructor
    organization
  end

end