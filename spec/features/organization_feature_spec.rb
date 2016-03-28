require 'rails_helper'

RSpec.describe "Organizations", type: :feature, :js => true do
  let(:organization){ create(:organization) }
  let(:instructor){ create(:instructor, organization_id: organization.id, password: "12345678") }

  before do
    login_as(instructor, :scope => :user)
    visit "/"
  end

  it "shows home page" do
    expect(page).to have_content 'University'
    expect(page).to have_content "Today's Events"
    expect(page).to have_content "No events are scheduled for today"
  end

  it "edits an organization" do
    find('a[data-target="#editOrganizationModal"]').click
    expect(page).to have_content 'Edit Organization'
    fill_in 'Organization Name', with: "Capybara Organization"
    click_on("Update Organization")
    expect(page).to have_content 'Capybara Organization'
    expect(page).to_not have_content 'University'
  end
end