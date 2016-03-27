require 'rails_helper'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

RSpec.describe "Items", type: :feature, :js => true do
  let(:organization){ create(:organization) }
  let(:instructor){ create(:instructor, organization_id: organization.id) }
  let(:item){ create(:disposable_item, organization_id: organization.id, quantity: 10) }

  before do
    login_as(instructor, :scope => :user)
    visit "/organizations/1/items"
  end

  it "shows items page" do
    expect(page).to have_content 'Inventory'
    expect(page).to have_content 'No items have been added'
  end

  it "adds an new item" do
    find('a[data-target="#newItemModal"]').click
    expect(page).to have_content 'Create a New Item'
    fill_in 'Item', with: "Capybara Item"
    fill_in 'Quantity', with: "42"
    find('#item_disposable').set(true)
    click_on("Create Item")
    expect(page).to have_content 'Capybara Item'
    expect(page).to have_content 'Scheduled Usage'
    expect(Item.all.count).to eq(1)
  end

  it "shows items page" do
    create(:disposable_item, organization_id: organization.id)
    visit "/organizations/1/items"
    expect(page).to have_content 'Test Item'
    click_on('Test Item')
    expect(page).to have_content 'Test Item'
    expect(page).to have_content 'Scheduled Usage'
  end

  it "edits an item" do
    create(:disposable_item, organization_id: organization.id)
    visit "/organizations/1/items"
    click_on('Test Item')
    find('a[data-target="#editItemModal"]').click
    expect(page).to have_content 'Edit Item'
    fill_in 'Item', with: "Capybara Item"
    fill_in 'Quantity', with: "42"
    click_on("Update Item")
    expect(page).to have_content 'Capybara Item'
    expect(page).to have_content '42'
    expect(page).to_not have_content 'Test Item'
  end

  it "deletes an item" do
    create(:disposable_item, organization_id: organization.id)
    visit "/organizations/1/items"
    accept_alert do
      find('a[data-method="delete"]').click
    end
    expect(page).to have_content 'No items have been added'
    expect(Item.all.count).to eq(0)
  end

end