require 'rails_helper'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

RSpec.describe "Courses", type: :feature, :js => true do
  let(:organization){ create(:organization) }
  let(:instructor){ create(:instructor, organization_id: organization.id) }

  before do
    login_as(instructor, :scope => :user)
    visit "/organizations/1/courses"
  end

  it "shows courses page" do
    expect(page).to have_content 'Courses'
    expect(page).to have_content 'No courses have been added'
  end

  it "adds a new course" do
    find('a[data-target="#newCourseModal"]').click
    expect(page).to have_content 'Create a New Course'
    fill_in 'Course', with: "Capybara Course"
    click_on("Create Course")
    expect(page).to have_content 'Capybara Course'
    expect(page).to have_content 'Course Schedule'
    expect(page).to have_content 'Students'
    expect(Course.all.count).to eq(1)
  end

  it "shows courses page" do
    p Organization.all
    create(:course, organization_id: organization.id, instructor_id: instructor.id)
    visit "/organizations/1/courses"
    expect(page).to have_content 'Test Course'
    click_on('Test Course')
    expect(page).to have_content 'Test Course'
    expect(page).to have_content 'Course Schedule'
    expect(page).to have_content 'Students'
  end

  xit "adds a student to the course" do
    create(:course, organization_id: organization.id, instructor_id: instructor.id)
    create(:student, organization_id: organization.id)
    visit "/organizations/1/courses"
    click_on('Test Course')
    fill_in 'Add Students', with: "Tes"
    find('.search-n-go-parent>input').native.send_keys(:return)
    expect(course.students.length).to eq(1)
    expect(course.students).to include(student)
  end

  it "edits a course" do
    create(:course, organization_id: organization.id, instructor_id: instructor.id)
    visit "/organizations/1/courses"
    click_on('Test Course')
    find('a[data-target="#editCourseModal"]').click
    expect(page).to have_content 'Edit Course'
    fill_in 'Course', with: "Capybara Course"
    click_on("Update Course")
    expect(page).to have_content 'Capybara Course'
    expect(page).to_not have_content 'Test Course'
  end

  it "deletes a course" do
    create(:course, organization_id: organization.id, instructor_id: instructor.id)
    visit "/organizations/1/courses"
    accept_alert do
      find('a[data-method="delete"]').click
    end
    expect(page).to have_content 'No courses have been added'
    expect(Course.all.count).to eq(0)
  end
end