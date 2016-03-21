require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  login_admin
  let(:organization) do
    Organization.first
  end
  let(:user) do
    User.create!(
      first_name: "Keith",
      last_name: "Conroy",
      email: "keith@mail.com",
      organization_id: organization.id,
      is_student: false,
      password: "12345678"
    )
  end
  context 'GET index' do
    before { get :index, organization_id: organization.id }
    it "should get index" do
      expect(response).to be_ok
      expect(response).to render_template("index")
    end
    it "gets users" do
      expect(assigns(:users)).to be_a(ActiveRecord::Relation)
    end
    it "assigns a user" do
      expect(assigns(:new_user)).to be_a(User)
    end
  end

  context "POST create" do
    it "saves a new user and redirects" do
      expect{ post :create, user: {first_name: "New", last_name: "User", email: "NU@mail.com", organization_id: organization.id, is_student: false, password: "12345678" }, organization_id: organization.id }.to change{User.count}.by 1
      expect(response.status).to eq 302
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
    it "should get show" do
      expect(response).to be_ok
      expect(response).to render_template("show")
    end
    it "gets user" do
      expect(assigns(:user)).to be_a(User)
    end
  end

  context "GET #edit" do
    before { get :edit, organization_id: organization.id, id: user.id }
    it "gets user" do
      expect(assigns(:user)).to be_a(User)
    end
  end

  context "PUT #update" do
    context "valid update" do
      before { put :update, organization_id: organization.id, id: user.id, user: {first_name: "Updated User"} }
      it "gets user" do
        expect(assigns(:user)).to be_a(User)
      end
      it "updates the user" do
        expect(User.last.first_name).to match(/Updated User/)
      end
      it "should redirect" do
        expect(response.status).to eq 302
      end
    end

    context "invalid update" do
      before { put :update, organization_id: organization.id, id: user.id, user: {first_name: ""} }
      it "should not update" do
        expect(User.first.first_name).to match(//)
      end
      it "should give an error status" do
        expect(response.status).to eq 400
      end
    end
  end

  context "DELETE #destroy" do
    before { delete :destroy, organization_id: organization.id, id: user.id }
    it "gets user" do
      expect(assigns(:user)).to be_a(User)
    end
    it "destroys the user" do
      expect(User.count).to eq 1
    end
    it "should redirect" do
      expect(response.status).to eq 302
    end
  end

  context "GET #search" do
    before { post :create, user: {first_name: "Keith", last_name: "Conroy", email: "kc@mail.com", organization_id: organization.id, is_student: false, password: "12345678" }, organization_id: organization.id }
    before { post :create, user: {first_name: "Lauren", last_name: "Conroy", email: "lc@mail.com", organization_id: organization.id, is_student: false, password: "12345678" }, organization_id: organization.id }
    before { post :create, user: {first_name: "Sandi", last_name: "Conroy", email: "sc@mail.com", organization_id: organization.id, is_student: false, password: "12345678" }, organization_id: organization.id }
    before { post :create, user: {first_name: "John", last_name: "Smith", email: "js@mail.com", organization_id: organization.id, is_student: false, password: "12345678" }, organization_id: organization.id }

    context 'valid search: full title match' do
      before { get :search, organization_id: organization.id, phrase: 'keith' }
      it "calls User.search" do
        expect(User).to respond_to(:search).with(2).argument
      end
      it "gets users" do
        expect(assigns(:users)).to be_a(ActiveRecord::Relation)
      end
      it "finds a match" do
        expect(assigns(:users)).not_to be_empty
        expect(assigns(:users).length).to eq(1)
        expect(assigns(:users).first.first_name).to eq("Keith")
      end
    end
    context 'valid search: partial match' do
      before { get :search, organization_id: organization.id, phrase: 'conroy' }
      it "finds two matches" do
        expect(assigns(:users).length).to eq(3)
        expect(assigns(:users).first.first_name).to eq("Keith")
        expect(assigns(:users)[1].first_name).to eq("Lauren")
        expect(assigns(:users).last.first_name).to eq("Sandi")
      end
    end
    context 'invalid search' do
      before { get :search, organization_id: organization.id, phrase: 'abc' }
      it "returns empty" do
        expect(assigns(:users)).to be_empty
      end
    end
    context 'empty search' do
      before { get :search, organization_id: organization.id }
      it "gets all users" do
        expect(assigns(:users).length).to eq(5)
      end
    end
  end

end



