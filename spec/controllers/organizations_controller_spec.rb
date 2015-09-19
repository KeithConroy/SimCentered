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
  let(:student) do
    User.create!(
      first_name: "Test",
      last_name: "Student",
      email: "student@mail.com",
      organization_id: organization.id,
      is_student: true,
    )
  end
  let(:course) do
    Course.create!(
      title: "Test Course",
      instructor_id: instructor.id,
      organization_id: organization.id,
    )
  end
  let(:room) do
    Room.create!(
      title: "Test Room",
      organization_id: organization.id,
    )
  end
  let(:item) do
    Item.create!(
      title: "Test Item",
      quantity: 1,
      organization_id: organization.id,
    )
  end
  let(:event) do
    Event.create!(
      title: "Test Event",
      instructor_id: instructor.id,
      organization_id: organization.id,
    )
  end

  context "POST create" do
    it "saves a new organization and redirects" do
      expect{ post :create, organization: {title: "New Organization", subdomain: "norg", email: "admin@mail.com"} }.to change{Organization.count}.by 1
      response.status.should eq 302
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
      response.should be_ok
    end
    it "gets organization" do
      assigns(:organization).should be_a(Organization)
    end
  end

  context "GET #edit" do
    before { get :edit, id: organization.id }
    it "gets organization" do
      assigns(:organization).should be_a(Organization)
    end
  end

  context "PUT #update" do
    context "valid update" do
      before { put :update, id: organization.id, organization: {title: "Updated organization"} }
      it "gets organization" do
        assigns(:organization).should be_a(Organization)
      end
      it "updates the organization" do
        Organization.first.title.should match(/Updated organization/)
      end
      it "should redirect" do
        response.status.should eq 302
      end
    end

    context "invalid update" do
      before { put :update, id: organization.id, organization: {title: ""} }
      it "should not update" do
        Organization.first.title.should match(//)
      end
      it "should give an error status" do
        response.status.should eq 400
      end
    end
  end

  context "DELETE #destroy" do
    before { delete :destroy, id: organization.id }
    it "gets organization" do
      assigns(:organization).should be_a(Organization)
    end
    it "destroys the organization" do
      Organization.count.should eq 0
    end
    xit "destroys the organizations courses" do
      Course.count.should eq 0
    end
    xit "destroys the organizations events" do
      Event.count.should eq 0
    end
    xit "destroys the organizations items" do
      Item.count.should eq 0
    end
    xit "destroys the organizations rooms" do
      Room.count.should eq 0
    end
    xit "destroys the organizations users" do
      User.count.should eq 0
    end
    it "should redirect" do
      response.status.should eq 302
    end
  end

  context "GET #search" do
    before { get :search, phrase: 'organization' }
    it "searches"
  end

end
