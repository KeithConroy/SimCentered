class ItemsController < ApplicationController
  before_action :find_item, only: [:show, :edit, :update, :destroy]

  def index
    @new_item = Item.new
    @items = Item
      .where(organization_id: @organization.id)
      .order(title: :asc)
      .paginate(page: params[:page], per_page: 15)

    return render :'items/_all_items', layout: false if request.xhr?
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
      render json: @item.errors.full_messages
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
      render json: @item.errors.full_messages
    end
  end

  def destroy
    @item.destroy
    redirect_to(:action => 'index')
  end

  def search
    @items = Item
      .where("organization_id = ? AND lower(title) LIKE ?", @organization.id, "%#{params[:phrase]}%")
      .order(title: :asc)
      .paginate(page: 1, per_page: 15)
    return render :'items/_all_items', layout: false
  end

  private

  def find_item
    @item = Item.where(id: params[:id]).first
  end

  def item_params
    params.require(:item).permit(:title, :quantity, :disposable)
  end
end
