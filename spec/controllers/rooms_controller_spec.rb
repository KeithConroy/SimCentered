require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  let(:organization) do
    Organization.create!(
      title: "University",
      subdomain: "uni"
    )
  end
  let(:room) do
    Room.create!(
      title: "Test Room",
      number: "308",
      building: "Forum",
      organization_id: organization.id,
    )
  end
  context 'GET index' do
    before { get :index, organization_id: organization.id }
    it "should get index" do
      expect(response).to be_ok
      expect(response).to render_template("index")
    end
    it "gets rooms" do
      expect(assigns(:rooms)).to be_a(ActiveRecord::Relation)
    end
    it "assigns a room" do
      expect(assigns(:new_room)).to be_a(Room)
    end
  end

  context "POST create" do
    it "saves a new room and redirects" do
      expect{ post :create, room: {title: "room", organization_id: organization.id}, organization_id: organization.id }.to change{Room.count}.by 1
      expect(response.status).to eq 302
    end
    it "does not saves a new room with invalid input - no title" do
      expect{ post :create, room: {title: ""}, organization_id: organization.id }.to_not change{Room.count}
    end
  end

  context "GET #show" do
    before { get :show, organization_id: organization.id, id: room.id }
    it "should get show" do
      expect(response).to be_ok
      expect(response).to render_template("show")
    end
    it "gets room" do
      expect(assigns(:room)).to be_a(Room)
    end
  end

  context "GET #edit" do
    before { get :edit, organization_id: organization.id, id: room.id }
    it "gets room" do
      expect(assigns(:room)).to be_a(Room)
    end
  end

  context "PUT #update" do
    context "valid update" do
      before { put :update, organization_id: organization.id, id: room.id, room: {title: "Updated room"} }
      it "gets room" do
        expect(assigns(:room)).to be_a(Room)
      end
      it "updates the room" do
        expect(Room.first.title).to match(/Updated room/)
      end
      it "should redirect" do
        expect(response.status).to eq 302
      end
    end

    context "invalid update" do
      before { put :update, organization_id: organization.id, id: room.id, room: {title: ""} }
      it "should not update" do
        expect(Room.first.title).to match(//)
      end
      it "should give an error status" do
        expect(response.status).to eq 400
      end
    end
  end

  context "DELETE #destroy" do
    before { delete :destroy, organization_id: organization.id, id: room.id }
    it "gets room" do
      expect(assigns(:room)).to be_a(Room)
    end
    it "destroys the room" do
      expect(Room.count).to eq 0
    end
    it "should redirect" do
      expect(response.status).to eq 302
    end
  end

  context "GET #search" do
    before { get :search, organization_id: organization.id, phrase: 'room' }
    it "searches"
  end

end


