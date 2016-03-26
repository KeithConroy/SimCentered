class ItemsController < ApplicationController
  before_action :find_item, only: [:show, :edit, :update, :destroy, :heatmap]

  include EventsHelper

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
    @events = @item.events
      .where('start > ?', DateTime.now)
      .paginate(page: 1, per_page: 10)
  end

  def edit
  end

  def update
    if @item.update_attributes(item_params)
      redirect_to organization_item_path(@organization.id, @item.id)
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

  def heatmap
    render json: heatmap_json(@item)
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

  def heatmap_json(item)
    data = item.disposable ? disposable_heatmap_data(item) : capital_heatmap_data(item)
    name = item.disposable ? ['item used', 'items used'] : ['hour', 'hours']
    unless data.empty?
      quarter = data.values.max / 4
      legend = [quarter,quarter*2,quarter*3,quarter*4]
    end

    { data: data, name: name, legend: legend || [2,4,6,8]}
  end

  def disposable_heatmap_data(item, data = {})
    item.scheduled_items.each do |entry|
      event = Event.where(id: entry.event_id).first
      if event.start < DateTime.now
        timestamp = event.start.to_i.to_s
        data[timestamp] = entry.quantity
      end
    end
    data
  end

  def capital_heatmap_data(item, data = {})
    item.events.each do |event|
      if event.start < DateTime.now
        timestamp = event.start.to_i.to_s
        data[timestamp] = event_duration(event)
      end
    end
    data
  end
end
