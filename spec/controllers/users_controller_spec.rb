require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:organization) do
    Organization.create!(
      title: "University",
      subdomain: "uni"
    )
  end
  let(:user) do
    User.create!(
      first_name: "Keith",
      last_name: "Conroy",
      email: "keith@mail.com",
      organization_id: organization.id,
      is_student: false,
    )
  end
  context 'GET index' do
    before { get :index, organization_id: organization.id }
    it "should get index" do
      response.should be_ok
    end
    it "gets users" do
      assigns(:users).should be_a(ActiveRecord::Relation)
    end
    it "assigns a user" do
      assigns(:new_user).should be_a(User)
    end
  end

  context "POST create" do
    it "saves a new user and redirects" do
      expect{ post :create, user: {first_name: "New", last_name: "User", email: "NU@mail.com", organization_id: organization.id, is_student: false }, organization_id: organization.id }.to change{User.count}.by 1
      response.status.should eq 302
    end
    it "does not saves a new user with invalid input - no first_name" do
      expect{ post :create, user: {last_name: "User", email: "NU@mail.com", organization_id: organization.id, is_student: false}, organization_id: organization.id }.to_not change{User.count}
    end
    it "does not saves a new user with invalid input - no last_name" do
      expect{ post :create, user: {first_name: "User", email: "NU@mail.com", organization_id: organization.id, is_student: false}, organization_id: organization.id }.to_not change{User.count}
    end
    it "does not saves a new user with invalid input - no email" do
      expect{ post :create, user: {first_name: "User", last_name: "User", organization_id: organization.id, is_student: false}, organization_id: organization.id }.to_not change{User.count}
    end
  end

  context "GET #show" do
    before { get :show, organization_id: organization.id, id: user.id }
    it "gets user" do
      assigns(:user).should be_a(User)
    end
    # it "assigns students" do
    #   assigns(:students).should be_a(ActiveRecord::Relation)
    # end
    # it "assigns student" do
    #   assigns(:student).should be_a(User)
    # end
  end

  context "GET #edit" do
    before { get :edit, organization_id: organization.id, id: user.id }
    it "gets user" do
      assigns(:user).should be_a(User)
    end
  end

  context "PUT #update" do
    context "valid update" do
      before { put :update, organization_id: organization.id, id: user.id, user: {first_name: "Updated User"} }
      it "gets user" do
        assigns(:user).should be_a(User)
      end
      it "updates the user" do
        User.first.first_name.should match(/Updated User/)
      end
      it "should redirect" do
        response.status.should eq 302
      end
    end

    context "invalid update" do
      before { put :update, organization_id: organization.id, id: user.id, user: {first_name: ""} }
      it "should not update" do
        User.first.first_name.should match(//)
      end
      it "should give an error status" do
        response.status.should eq 400
      end
    end
  end

  context "DELETE #destroy" do
    before { delete :destroy, organization_id: organization.id, id: user.id }
    it "gets user" do
      assigns(:user).should be_a(User)
    end
    it "destroys the user" do
      User.count.should eq 0
    end
    it "should redirect" do
      response.status.should eq 302
    end
  end

  context "GET #search" do
    before { get :search, organization_id: organization.id, phrase: 'user' }
    it "searches"
  end

end



