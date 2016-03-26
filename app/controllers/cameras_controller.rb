class CamerasController < ApplicationController
  before_action :find_camera, only: [:show, :edit, :update, :destroy]

  def index
    @new_camera = Camera.new
    @cameras = Camera.list(@organization.id, params[:page])
      .where(organization_id: @organization.id)
      .order(name: :asc)
      .paginate(page: params[:page], per_page: 15)
    @rooms = find_rooms

    render :'cameras/_all_cameras', layout: false if request.xhr?
  end

  def new
    @camera = Camera.new
  end

  def create
    @camera = Camera.new(camera_params)
    @camera.organization_id = @organization.id
    if @camera.save
      redirect_to organization_camera_path(@organization.id, @camera.id)
    else
      render json: @camera.errors.full_messages, status: 400
    end
  end

  def show
    @rooms = find_rooms
  end

  def edit
  end

  def update
    if @camera.update_attributes(camera_params)
      redirect_to organization_camera_path(@organization.id, @camera.id)
    else
      render json: @camera.errors.full_messages, status: 400
    end
  end

  def destroy
    @camera.destroy
    redirect_to(action: 'index')
  end

  def search
    @cameras = Camera
      .search(@organization.id, params[:phrase])
      .paginate(page: 1, per_page: 15)
    render :'cameras/_all_cameras', layout: false
  end

  def live
    @rooms = Room.local(@organization.id)
  end

  def recorded
    @rooms = Room.local(@organization.id)
  end

  private

  def find_camera
    @camera = Camera.where(organization_id: @organization.id, id: params[:id]).first
    unless @camera
      render file: "public/404.html"
    end
  end

  def camera_params
    params.require(:camera).permit(:name, :ip_address, :room_id, :serial_number)
  end

  def find_rooms
    Room.local(@organization.id).map do |room|
      [room.title, room.id]
    end
  end
end
