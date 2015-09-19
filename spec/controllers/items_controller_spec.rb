require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:organization) do
    Organization.create!(
      title: "University",
      subdomain: "uni"
    )
  end
  let(:item) do
    Item.create!(
      title: "Test Item",
      quantity: 1,
      organization_id: organization.id,
    )
  end
  context 'GET index' do
    before { get :index, organization_id: organization.id }
    it "should get index" do
      response.should be_ok
    end
    it "gets items" do
      assigns(:items).should be_a(ActiveRecord::Relation)
    end
    it "assigns a item" do
      assigns(:new_item).should be_a(Item)
    end
  end

  context "POST create" do
    it "saves a new item and redirects" do
      expect{ post :create, item: {title: "item", quantity: 1, organization_id: organization.id}, organization_id: organization.id }.to change{Item.count}.by 1
      response.status.should eq 302
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
    it "gets item" do
      assigns(:item).should be_a(Item)
    end
    # it "assigns students" do
    #   assigns(:students).should be_a(ActiveRecord::Relation)
    # end
    # it "assigns student" do
    #   assigns(:student).should be_a(User)
    # end
  end

  context "GET #edit" do
    before { get :edit, organization_id: organization.id, id: item.id }
    it "gets item" do
      assigns(:item).should be_a(Item)
    end
  end

  context "PUT #update" do
    context "valid update" do
      before { put :update, organization_id: organization.id, id: item.id, item: {title: "Updated Item"} }
      it "gets item" do
        assigns(:item).should be_a(Item)
      end
      it "updates the item" do
        Item.first.title.should match(/Updated Item/)
      end
      it "should redirect" do
        response.status.should eq 302
      end
    end

    context "invalid update" do
      before { put :update, organization_id: organization.id, id: item.id, item: {title: ""} }
      it "should not update" do
        Item.first.title.should match(//)
      end
      it "should give an error status" do
        response.status.should eq 400
      end
    end
  end

  context "DELETE #destroy" do
    before { delete :destroy, organization_id: organization.id, id: item.id }
    it "gets item" do
      assigns(:item).should be_a(Item)
    end
    it "destroys the item" do
      Item.count.should eq 0
    end
    it "should redirect" do
      response.status.should eq 302
    end
  end

  context "GET #search" do
    before { get :search, organization_id: organization.id, phrase: 'item' }
    it "searches"
  end

end

