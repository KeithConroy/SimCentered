require 'rails_helper'

RSpec.describe "Rooms", type: :feature, :js => true do
  let(:organization){ create(:organization) }
  let(:instructor){ create(:instructor, organization_id: organization.id) }

  before do
    login_as(instructor, :scope => :user)
    visit "/organizations/1/rooms"
  end

  it "shows rooms page" do
    expect(page).to have_content 'Rooms'
    expect(page).to have_content 'No rooms have been added'
  end

  it "adds a new room" do
    find('a[data-target="#newRoomModal"]').click
    expect(page).to have_content 'Create a New Room'
    fill_in 'Title', with: "Capybara Room"
    fill_in 'Number', with: "101"
    fill_in 'Building', with: "Testing"
    click_on("Create Room")
    expect(page).to have_content 'Capybara Room'
    expect(page).to have_content 'Room Schedule'
    expect(Room.all.count).to eq(1)
  end

  it "shows rooms page" do
    create(:room, organization_id: organization.id)
    visit "/organizations/1/rooms"
    expect(page).to have_content 'Test Room'
    click_on('Test Room')
    expect(page).to have_content 'Test Room'
    expect(page).to have_content 'Room Schedule'
  end

  it "edits a room" do
    create(:room, organization_id: organization.id)
    visit "/organizations/1/rooms"
    click_on('Test Room')
    find('a[data-target="#editRoomModal"]').click
    expect(page).to have_content 'Edit Room'
    fill_in 'Title', with: "Capybara Room"
    fill_in 'Number', with: "999"
    fill_in 'Building', with: "New Building"
    click_on("Update Room")
    expect(page).to have_content 'Capybara Room'
    expect(page).to have_content '999'
    expect(page).to have_content 'New Building'
    expect(page).to_not have_content 'Test Room'
  end

  it "deletes a room" do
    create(:room, organization_id: organization.id)
    visit "/organizations/1/rooms"
    accept_alert do
      find('a[data-method="delete"]').click
    end
    expect(page).to have_content 'No rooms have been added'
    expect(Room.all.count).to eq(0)
  end

end