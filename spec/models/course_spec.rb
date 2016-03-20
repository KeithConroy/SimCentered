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
  let(:course3) do
    Course.create!(
      title: "Test Course3",
      instructor_id: instructor.id,
      organization_id: organization.id,
    )
  end
  let(:organization2) do
    Organization.create!(
      title: "University2",
      subdomain: "uni2"
    )
  end
  let(:instructor2) do
    User.create!(
      first_name: "Keith",
      last_name: "Conroy",
      email: "keith2@mail.com",
      organization_id: organization2.id,
      is_student: false,
    )
  end
  let(:course2) do
    Course.create!(
      title: "Test Course2",
      instructor_id: instructor2.id,
      organization_id: organization2.id,
    )
  end
  before (:each) do
    course.save
    course2.save
    course3.save
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

  context '#local' do
    it 'returns an ActiveRecord Relation' do
      expect(Course.local(organization.id)).to be_a(ActiveRecord::Relation)
    end
    it 'only returns courses for given organization' do
      courses = Course.local(organization.id)
      expect(Course.all.length).to eq(3)
      expect(courses.length).to eq(2)
      expect(courses.all? {|course| course.organization_id == organization.id}).to eq(true)
    end
  end

  context '#list' do
  end

  context '#search' do
    context 'valid search: full title match' do
      it "returns an ActiveRecord Relation" do
        expect(Course.search(organization.id, 'test')).to be_a(ActiveRecord::Relation)
      end
      it "finds a match" do
        courses = Course.search(organization.id, 'test course3')
        expect(courses).not_to be_empty
        expect(courses.length).to eq(1)
        expect(courses.first.title).to eq("Test Course3")
      end
    end
    context 'valid search: partial match' do
      it "finds two matches" do
        courses = Course.search(organization.id, 'test')
        expect(courses.length).to eq(2)
        expect(courses.first.title).to eq("Test Course")
        expect(courses.last.title).to eq("Test Course3")
      end
    end
    context 'invalid search' do
      it "returns empty" do
        courses = Course.search(organization.id, 'abc')
        expect(courses).to be_empty
      end
    end
    context 'empty search' do
      it "gets all courses" do
        courses = Course.search(organization.id, nil)
        expect(courses.length).to eq(2)
      end
    end
  end
end
