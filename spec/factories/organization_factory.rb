FactoryGirl.define do
  factory :organization do
    title "University"
    subdomain "uni"

    factory :other_org do
      title "Other University"
      subdomain "ouni"
    end
  end
end