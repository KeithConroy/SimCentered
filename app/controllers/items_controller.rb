class ItemsController < ApplicationController
  before_action :find_item, only: [:show, :edit, :update, :destroy]

  def index
    @new_item = Item.new
    @items = Item.list(@organization.id, params[:page])
      .local(@organization.id)
      .order(title: :asc)
      .paginate(page: params[:page], per_page: 15)

    render :'items/_all_items', layout: false if request.xhr?
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.organization_id = @organization.id
    if @item.save
      redirect_to @item
    else
      render json: @item.errors.full_messages, status: 400
    end
  end

  def show
    @events = @item.events
      .where('start > ?', DateTime.now)
      .paginate(page: 1, per_page: 10)
  end

  def edit
  end

  def update
    if @item.update_attributes(item_params)
      redirect_to @item
    else
      render json: @item.errors.full_messages, status: 400
    end
  end

  def destroy
    @item.destroy
    redirect_to(action: 'index')
  end

  def search
    @items = Item
      .search(@organization.id, params[:phrase])
      .paginate(page: 1, per_page: 15)
    render :'items/_all_items', layout: false
  end

  private

  def find_item
    @item = Item.where(organization_id: @organization.id, id: params[:id]).first
    unless @item
      render file: "public/404.html"
    end
  end

  def item_params
    params.require(:item).permit(:title, :quantity, :disposable)
  end
end
