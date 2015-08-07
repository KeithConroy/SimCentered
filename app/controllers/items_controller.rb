class ItemsController < ApplicationController
  before_action :find_organization
  before_action :find_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.where(organization_id: @organization.id).order(title: :asc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.organization_id = @organization.id
    if @item.save
      redirect_to organization_item_path(@organization.id, @item.id)
    else
      render json: "no"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update_attributes(item_params)
      redirect_to organization_item_path(@organization.id, @item.id)
    else

    end
  end

  def destroy
    @item.destroy
    redirect_to(:action => 'index')
  end

  private

  def find_organization
    @organization = Organization.where(id: params[:organization_id]).first
  end

  def find_item
    @item = Item.where(id: params[:id]).first
  end

  def item_params
    params.require(:item).permit(:title, :quantity, :disposable)
  end
end
