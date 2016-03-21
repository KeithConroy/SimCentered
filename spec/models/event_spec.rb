require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:organization) do
    Organization.create!(
      title: "University",
      subdomain: "uni"
    )
  end
  let(:instructor) do
    User.create!(
      first_name: "Keith",
      last_name: "Conroy",
      email: "keith@mail.com",
      organization_id: organization.id,
      is_student: false,
      password: "12345678"
    )
  end
  let(:event) do
    Event.create!(
      title: "Test Event",
      instructor_id: instructor.id,
      organization_id: organization.id,
    )
  end
  context 'validation' do
    it "fails validation with no title" do
      event = Event.new(
        instructor_id: instructor.id,
        organization_id: organization.id,
      )
      event.valid?
      expect(event.errors[:title].size).to eq(1)
    end
    it "fails validation with no organization_id" do
      event = Event.new(
        title: "Test Event",
        instructor_id: instructor.id,
      )
      event.valid?
      expect(event.errors[:organization_id].size).to eq(1)
    end
  end
end
