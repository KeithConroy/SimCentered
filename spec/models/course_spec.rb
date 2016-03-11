require 'rails_helper'

RSpec.describe Course, type: :model do
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
    )
  end
  let(:course) do
    Course.create!(
      title: "Test Course",
      instructor_id: instructor.id,
      organization_id: organization.id,
    )
  end
  context 'validation' do
    it "fails validation with no title" do
      course = Course.new(
        instructor_id: instructor.id,
        organization_id: organization.id,
      )
      course.valid?
      expect(course.errors[:title].size).to eq(1)
    end
    it "fails validation with no organization_id" do
      course = Course.new(
        title: "Test Course",
        instructor_id: instructor.id,
      )
      course.valid?
      expect(course.errors[:organization_id].size).to eq(1)
    end
  end
end
