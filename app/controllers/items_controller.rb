class ItemsController < ApplicationController

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
      redirect_to organization_item_path(@organization.id, @item.id)
    else
      render json: @item.errors.full_messages, status: 400
    end
  end

  def show
    @item = find_item
    @events = @item.events
      .where('start > ?', DateTime.now)
      .paginate(page: 1, per_page: 10)
  end

  def edit
    @item = find_item
  end

  def update
    @item = find_item
    if @item.update_attributes(item_params)
      redirect_to organization_item_path(@organization.id, @item.id)
    else
      render json: @item.errors.full_messages, status: 400
    end
  end

  def destroy
    @item = find_item
    @item.destroy
    redirect_to(action: 'index')
  end

  def search
    @items = Item
      .search(@organization.id, params[:phrase])
      .paginate(page: 1, per_page: 15)
    render :'items/_all_items', layout: false
  end

  def heatmap
    @item = find_item
    render json: @item.heatmap_json
  end

  private

  def find_item
    authorize_resource(Item.where(id: params[:id]).first)
  end

  def item_params
    params.require(:item).permit(:title, :quantity, :disposable)
  end
end
