require 'rails_helper'

describe UsersHelper do
  let(:organization) do
    Organization.create!(
      title: "University",
      subdomain: "uni"
    )
  end
  let(:user) do
    User.create!(
      first_name: "Keith",
      last_name: "Conroy",
      email: "keith@mail.com",
      organization_id: organization.id,
      is_student: false,
    )
  end
  let(:student) do
    User.create!(
      first_name: "Test",
      last_name: "Student",
      email: "student@mail.com",
      organization_id: organization.id,
      is_student: true,
    )
  end
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