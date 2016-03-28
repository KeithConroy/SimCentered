require 'rails_helper'

RSpec.describe "Events", type: :feature, :js => true do
  let(:organization){ create(:organization) }
  let(:instructor){ create(:instructor, organization_id: organization.id) }

end