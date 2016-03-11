require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:organization) do
    Organization.create!(
      title: "University",
      subdomain: "uni"
    )
  end
  let(:room) do
    Room.create!(
      title: "Test Room",
      organization_id: organization.id,
    )
  end
  context 'validation' do
    it "fails validation with no title" do
      room = Room.new(
        organization_id: organization.id,
      )
      room.valid?
      expect(room.errors[:title].size).to eq(1)
    end
    it "fails validation with no organization_id" do
      room = Room.new(
        title: "Test Room",
      )
      room.valid?
      expect(room.errors[:organization_id].size).to eq(1)
    end
  end
end
