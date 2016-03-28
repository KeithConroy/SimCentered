require 'rails_helper'

RSpec.describe "Sessions", type: :feature, :js => true do
  let(:organization){ create(:organization) }
  let(:instructor){ create(:instructor, organization_id: organization.id, password: "12345678") }

  before do
    instructor.save
  end

  it "shows home page" do
    visit "/"
    expect(page).to have_content 'SimCentered'
    expect(page).to have_content 'Sign In'
  end
  it "signs in" do
    visit "/"
    click_on("Sign In")
    fill_in 'Email', with: "keith@mail.com"
    fill_in 'Password', with: "12345678"
    click_on("Log in")
    expect(page).to have_content 'University'
  end
end