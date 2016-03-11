require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
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

  context "POST create" do
    it "saves a new organization and redirects" do
      expect{ post :create, organization: {title: "New Organization", subdomain: "norg", email: "admin@mail.com"} }.to change{Organization.count}.by 1
      expect(response.status).to eq 302
    end
    it "does not saves a new organization with invalid input - no title" do
      expect{ post :create, organization: {title: "", subdomain: "empty", email: "admin@mail.com"} }.to_not change{Organization.count}
    end
    it "does not saves a new organization with invalid input- no subdomain" do
      expect{ post :create, organization: {title: "organization", email: "admin@mail.com"} }.to_not change{Organization.count}
    end
  end

  context "GET #show" do
    before { get :show, id: organization.id }
    it "should get show" do
      expect(response).to be_ok
      expect(response).to render_template("show")
    end
    it "gets organization" do
      expect(assigns(:organization)).to be_a(Organization)
    end
  end

  context "GET #edit" do
    before { get :edit, id: organization.id }
    it "gets organization" do
      expect(assigns(:organization)).to be_a(Organization)
    end
  end

  context "PUT #update" do
    context "valid update" do
      before { put :update, id: organization.id, organization: {title: "Updated organization"} }
      it "gets organization" do
        expect(assigns(:organization)).to be_a(Organization)
      end
      it "updates the organization" do
        expect(Organization.first.title).to match(/Updated organization/)
      end
      it "should redirect" do
        expect(response.status).to eq 302
      end
    end

    context "invalid update" do
      before { put :update, id: organization.id, organization: {title: ""} }
      it "should not update" do
        expect(Organization.first.title).to match(//)
      end
      it "should give an error status" do
        expect(response.status).to eq 400
      end
    end
  end

  context "DELETE #destroy" do
    before {
      Course.create!(
        title: "Test Course",
        instructor_id: instructor.id,
        organization_id: organization.id,
      )
      Room.create!(
        title: "Test Room",
        organization_id: organization.id,
      )
      Event.create!(
        title: "Test Event",
        instructor_id: instructor.id,
        organization_id: organization.id,
      )
      Item.create!(
        title: "Test Item",
        quantity: 1,
        organization_id: organization.id,
      )
    }
    it "gets organization" do
      delete :destroy, id: organization.id
      expect(assigns(:organization)).to be_a(Organization)
    end
    it "destroys the organization" do
      expect{ delete :destroy, id: organization.id }.to change{Organization.count}.from(1).to(0)
    end
    it "destroys the organizations courses" do
      expect{ delete :destroy, id: organization.id }.to change{Course.count}.from(1).to(0)
    end
    it "destroys the organizations events" do
      expect{ delete :destroy, id: organization.id }.to change{Event.count}.from(1).to(0)
    end
    it "destroys the organizations items" do
      expect{ delete :destroy, id: organization.id }.to change{Item.count}.from(1).to(0)
    end
    it "destroys the organizations rooms" do
      expect{ delete :destroy, id: organization.id }.to change{Room.count}.from(1).to(0)
    end
    it "destroys the organizations users" do
      expect{ delete :destroy, id: organization.id }.to change{User.count}.from(1).to(0)
    end
    it "should redirect" do
      delete :destroy, id: organization.id
      expect(response.status).to eq 302
    end
  end

end
