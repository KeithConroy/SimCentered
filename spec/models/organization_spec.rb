require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:organization) do
    Organization.create!(
      title: "University",
      subdomain: "uni"
    )
  end
  context 'validation' do
    it "fails validation with no title" do
      organization = Organization.new(
        subdomain: "uni"
      )
      organization.valid?
      expect(organization.errors[:title].size).to eq(1)
    end
    it "fails validation with no subdomain" do
      organization = Organization.new(
        title: "University",
      )
      organization.valid?
      expect(organization.errors[:subdomain].size).to eq(1)
    end
    it "fails validation with duplicate title" do
      organization.save
      organization2 = Organization.new(
        title: "University",
        subdomain: "uni"
      )
      organization2.valid?
      expect(organization2.errors[:title].size).to eq(1)
    end
    it "fails validation with duplicate subdomain" do
      organization.save
      organization2 = Organization.new(
        title: "University",
        subdomain: "uni"
      )
      organization2.valid?
      expect(organization2.errors[:subdomain].size).to eq(1)
    end
  end
end
