require 'rails_helper'

RSpec.describe User, type: :model do
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
      password: "12345678"
    )
  end
  context 'validation' do
    it "fails validation with no first_name" do
      user = User.new(
        last_name: "Conroy",
        email: "keith@mail.com",
        organization_id: organization.id,
        password: "12345678"
      )
      user.valid?
      expect(user.errors[:first_name].size).to eq(1)
    end
    it "fails validation with no last_name" do
      user = User.new(
        first_name: "Keith",
        email: "keith@mail.com",
        organization_id: organization.id,
        password: "12345678"
      )
      user.valid?
      expect(user.errors[:last_name].size).to eq(1)
    end
    it "fails validation with no email" do
      user = User.new(
        first_name: "Keith",
        last_name: "Conroy",
        organization_id: organization.id,
        password: "12345678"
      )
      user.valid?
      expect(user.errors[:email].size).to eq(1)
      expect(user.errors[:email][0]).to eq("can't be blank")
    end
    it "fails validation with no organization_id" do
      user = User.new(
        first_name: "Keith",
        last_name: "Conroy",
        email: "keith@mail.com",
        password: "12345678"
      )
      user.valid?
      expect(user.errors[:organization_id].size).to eq(1)
    end
    it "fails validation with no password" do
      user = User.new(
        first_name: "Keith",
        last_name: "Conroy",
        email: "keith@mail.com",
        organization_id: organization.id,
      )
      user.valid?
      expect(user.errors[:password].size).to eq(1)
      expect(user.errors[:password][0]).to eq("can't be blank")
    end
    it "fails validation with duplicate email" do
      user.save
      user2 = User.new(
        first_name: "Keith",
        last_name: "Conroy",
        email: "keith@mail.com",
        organization_id: organization.id,
      )
      user2.valid?
      expect(user2.errors[:email].size).to eq(1)
      expect(user2.errors[:email][0]).to eq("has already been taken")
    end
  end
end
