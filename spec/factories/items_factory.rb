FactoryGirl.define do

  factory :item do

    factory :disposable_item do
      title "Test Item"
      quantity 100
      disposable true
    end

    factory :capital_item do
      title "Test Item"
      disposable false
    end

    organization
  end

end