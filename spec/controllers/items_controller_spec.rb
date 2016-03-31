require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  login_admin

  let(:organization){ Organization.first }
  let(:item){ create(:disposable_item, organization_id: organization.id) }
  let(:capital_item){ create(:capital_item, organization_id: organization.id) }
  let(:instructor){ create(:instructor, organization_id: organization.id) }
  let(:event){ create(:event, organization_id: organization.id, instructor_id: instructor.id)}

  context 'GET index' do
    before { get :index, organization_id: organization.id }
    it "should get index" do
      expect(response).to be_ok
      expect(response).to render_template("index")
    end
    it "gets items" do
      expect(assigns(:items)).to be_a(ActiveRecord::Relation)
    end
    it "assigns a item" do
      expect(assigns(:new_item)).to be_a(Item)
    end
  end

  context 'GET new' do
    before { get :new, organization_id: organization.id }
    it "should get new" do
      expect(response).to be_ok
      expect(response).to render_template("new")
      expect(assigns(:item)).to be_a(Item)
    end
  end

  context "POST create" do
    it "saves a new item and redirects" do
      expect{ post :create, item: {title: "item", quantity: 1, organization_id: organization.id}, organization_id: organization.id }.to change{Item.count}.by 1
      expect(response.status).to eq 302
    end
    it "does not saves a new item with invalid input - no title" do
      expect{ post :create, item: {title: "", quantity: 1}, organization_id: organization.id }.to_not change{Item.count}
    end
    it "does not saves a new item with invalid input- no quantity" do
      expect{ post :create, item: {title: "Item"}, organization_id: organization.id }.to_not change{Item.count}
    end
  end

  context "GET #show" do
    before { get :show, organization_id: organization.id, id: item.id }
    it "should get show" do
      expect(response).to be_ok
      expect(response).to render_template("show")
    end
    it "gets item" do
      expect(assigns(:item)).to be_a(Item)
    end
    it "renders 404 with invalid item" do
      get :show, organization_id: organization.id, id: 42
      expect(response.status).to eq 404
    end
  end

  context "GET #edit" do
    before { get :edit, organization_id: organization.id, id: item.id }
    it "gets item" do
      expect(assigns(:item)).to be_a(Item)
    end
    it "renders 404 with invalid item" do
      get :edit, organization_id: organization.id, id: 42
      expect(response.status).to eq 404
    end
  end

  context "PUT #update" do
    context "valid update" do
      before { put :update, organization_id: organization.id, id: item.id, item: {title: "Updated Item"} }
      it "gets item" do
        expect(assigns(:item)).to be_a(Item)
      end
      it "updates the item" do
        expect(Item.first.title).to match(/Updated Item/)
      end
      it "should redirect" do
        expect(response.status).to eq 302
      end
    end

    context "invalid update" do
      before { put :update, organization_id: organization.id, id: item.id, item: {title: ""} }
      it "should not update" do
        expect(Item.first.title).to match(//)
      end
      it "should give an error status" do
        expect(response.status).to eq 400
      end
      it "will not update organization_id" do
        put :update, organization_id: organization.id, id: item.id, item: {organization_id: 123}
        expect(item.organization_id).to_not eq(123)
      end
      it "renders 404 with invalid item" do
        put :update, organization_id: organization.id, id: 42, item: {title: "Updated Item"}
        expect(response.status).to eq 404
      end
    end
  end

  context "DELETE #destroy" do
    before { delete :destroy, organization_id: organization.id, id: item.id }
    it "gets item" do
      expect(assigns(:item)).to be_a(Item)
    end
    it "destroys the item" do
      expect(Item.count).to eq 0
    end
    it "should redirect" do
      expect(response.status).to eq 302
    end
    it "renders 404 with invalid item" do
      delete :destroy, organization_id: organization.id, id: 42
      expect(response.status).to eq 404
    end
  end

  context "GET #search" do
    before { post :create, item: {title: "SimMan", quantity: 1}, organization_id: organization.id }
    before { post :create, item: {title: "SimMan 3G", quantity: 1}, organization_id: organization.id }
    before { post :create, item: {title: "Gloves", quantity: 1}, organization_id: organization.id }

    context 'valid search: full title match' do
      before { get :search, organization_id: organization.id, phrase: 'simman 3g' }
      it "calls Item.search" do
        expect(Item).to respond_to(:search).with(2).argument
      end
      it "gets items" do
        expect(assigns(:items)).to be_a(ActiveRecord::Relation)
      end
      it "finds a match" do
        expect(assigns(:items)).not_to be_empty
        expect(assigns(:items).length).to eq(1)
        expect(assigns(:items).first.title).to eq("SimMan 3G")
      end
    end
    context 'valid search: partial match' do
      before { get :search, organization_id: organization.id, phrase: 'simMan' }
      it "finds two matches" do
        expect(assigns(:items).length).to eq(2)
        expect(assigns(:items).first.title).to eq("SimMan")
        expect(assigns(:items).last.title).to eq("SimMan 3G")
      end
    end
    context 'invalid search' do
      before { get :search, organization_id: organization.id, phrase: 'abc' }
      it "returns empty" do
        expect(assigns(:items)).to be_empty
      end
    end
    context 'empty search' do
      before { get :search, organization_id: organization.id }
      it "gets all items" do
        expect(assigns(:items).length).to eq(3)
      end
    end
  end

  context "GET #heatmap" do
    before { event.items << item }
    before do
      scheduled_item = event.scheduled_items.where(item_id: item.id).first
      scheduled_item.quantity = 2
      scheduled_item.save
    end
    before { event.items << capital_item }
    before { get :heatmap, organization_id: organization.id, id: item.id }

    it "should get heatmap" do
      expect(response).to be_ok
      body = JSON.parse(response.body)
      expect(body["data"]).to be_a(Hash)
      expect(body["name"]).to be_a(Array)
      expect(body["legend"]).to be_a(Array)
    end

    it "gets disposable heatmap" do
      get :heatmap, organization_id: organization.id, id: item.id
      body = JSON.parse(response.body)
      expect(body["data"][event.start.to_i.to_s]).to eq(2)
      expect(body["name"]).to eq(["item used", "items used"])
    end

    it "gets capital heatmap" do
      get :heatmap, organization_id: organization.id, id: capital_item.id
      body = JSON.parse(response.body)
      expect(body["data"][event.start.to_i.to_s]).to eq(1)
      expect(body["name"]).to eq(["hour", "hours"])
    end

    it "renders 400 with invalid item" do
      get :heatmap, organization_id: organization.id, id: 42
      expect(response.status).to eq 400
    end
  end
end

