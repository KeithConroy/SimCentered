module RoomsHelper
  def room_name(id)
    Room.where(id: id).first.title
  end
end
