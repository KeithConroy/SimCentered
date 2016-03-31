class ItemsController < ApplicationController
  include EventsHelper
  include ItemHeatmap

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
    begin
      @item = find_item
      @events = @item.events
        .where('start > ?', DateTime.now)
        .paginate(page: 1, per_page: 10)
    rescue => e
      render file: 'public/404.html', status: 404
    end
  end

  def edit
    begin
      @item = find_item
    rescue => e
      render file: 'public/404.html', status: 404
    end
  end

  def update
    begin
      @item = find_item
      if @item.update_attributes(item_params)
        redirect_to organization_item_path(@organization.id, @item.id)
      else
        render json: @item.errors.full_messages, status: 400
      end
    rescue => e
      render file: 'public/404.html', status: 404
    end
  end

  def destroy
    begin
      @item = find_item
      @item.destroy
      redirect_to(action: 'index')
    rescue => e
      render file: 'public/404.html', status: 404
    end
  end

  def search
    @items = Item
      .search(@organization.id, params[:phrase])
      .paginate(page: 1, per_page: 15)
    render :'items/_all_items', layout: false
  end

  private

  def find_item
    authorize_resource(Item.where(id: params[:id]).first)
  end

  def item_params
    params.require(:item).permit(:title, :quantity, :disposable)
  end
end
