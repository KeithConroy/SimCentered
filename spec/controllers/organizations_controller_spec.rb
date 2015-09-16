require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let(:organization) do
    Organization.create!(
      title: "University",
      subdomain: "uni"
    )
  end
  context 'GET show' do
    before { get :show }
    it "should get show" do
      response.should be_ok
    end
    it "gets organization" do
      assigns(:organization).should be_a(Organization)
    end
  end
end
