require 'rails_helper'

describe UsersHelper do
  let(:organization){ create(:organization) }
  let(:user){ create(:instructor, organization_id: organization.id) }
  let(:student){ create(:student, organization_id: organization.id) }

  describe "#full_name" do
    it "returns a users full name" do
      expect(full_name(user)).to eq("Keith Conroy")
    end
  end
  describe "#status" do
    it "returns a faculty status" do
      expect(status(user)).to eq("Faculty")
    end
    it "returns a student status" do
      expect(status(student)).to eq("Student")
    end
  end
end