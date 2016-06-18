require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:organization){ create(:organization) }

  context 'validation' do
    it "fails validation with no title" do
      item = Item.new(
        quantity: 1,
        organization_id: organization.id,
      )
      item.valid?
      expect(item.errors[:title].size).to eq(1)
    end
    it "fails validation with no quantity" do
      item = Item.new(
        title: "Test Item",
        organization_id: organization.id,
      )
      item.valid?
      expect(item.errors[:quantity].size).to eq(1)
    end
    it "fails validation with no organization_id" do
      item = Item.new(
        title: "Test Item",
        quantity: 1,
      )
      item.valid?
      expect(item.errors[:organization_id].size).to eq(1)
    end
  end

  context "#heatmap_json" do
    xit "calculates the heatmap json" do
    end
  end
end
