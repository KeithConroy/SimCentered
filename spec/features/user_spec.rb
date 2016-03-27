require 'rails_helper'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

RSpec.describe "Users", type: :feature, :js => true do
  let(:organization){ create(:organization) }
  let(:instructor){ create(:instructor, organization_id: organization.id) }

  before do
    login_as(instructor, :scope => :user)
    visit "/organizations/1/users"
  end

  it "shows users page" do
    expect(page).to have_content 'Users'
    expect(page).to have_content 'Keith Conroy'
  end

  it "adds a new user" do
    find('a[data-target="#newUserModal"]').click
    expect(page).to have_content 'Create a New User'
    fill_in 'First Name', with: "Capybara"
    fill_in 'Last Name', with: "User"
    fill_in 'Email', with: "capybara@mail.com"
    fill_in 'Password', with: "12345678"
    click_on("Create User")
    expect(page).to have_content 'Capybara User'
    expect(page).to have_content 'capybara@mail.com'
    expect(page).to have_content 'Schedule'
    expect(User.all.count).to eq(2)
  end

  it "shows users page" do
    create(:student, organization_id: organization.id)
    visit "/organizations/1/users"
    expect(page).to have_content 'Test Student'
    click_on('Test Student')
    expect(page).to have_content 'Test Student'
    expect(page).to have_content 'Schedule'
  end

  it "edits a user" do
    create(:student, organization_id: organization.id)
    visit "/organizations/1/users"
    click_on('Test Student')
    find('a[data-target="#editUserModal"]').click
    expect(page).to have_content 'Edit User'
    fill_in 'First Name', with: "Capybara"
    fill_in 'Last Name', with: "User"
    fill_in 'Email', with: "capybara@mail.com"
    fill_in 'Password', with: "12345678"
    click_on("Update User")
    expect(page).to have_content 'Capybara User'
    expect(page).to have_content 'capybara@mail.com'
    expect(page).to_not have_content 'Test User'
  end

  it "deletes a user" do
    create(:student, organization_id: organization.id)
    visit "/organizations/1/users"
    accept_alert do
      all('a[data-method="delete"]').last.click
    end
    expect(page).to have_content 'Keith Conroy'
    expect(page).to_not have_content 'Test Student'
    expect(User.all.count).to eq(1)
  end
end