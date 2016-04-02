module EventSearch
  extend ActiveSupport::Concern

  def search
    @events = Event.search(@organization.id, params[:phrase])
    render :'events/_all_events', layout: false
  end

  def modify_search
    @event = find_event || return
    search_all
    conflicting_events = Event.conflicting(@organization.id, @event)
    find_busy(conflicting_events) unless conflicting_events.empty?

    render :'events/_modify_search', layout: false
  end

  private

  def search_all
    search_available_courses
    search_available_students
    search_available_rooms
    search_available_items
  end

  def search_available_courses
    @courses = Course.search(@organization.id, params[:phrase])
    @courses -= @event.courses
  end

  def search_available_students
    @students = User.search_students(@organization.id, params[:phrase])
    @students -= @event.students
  end

  def search_available_rooms
    @rooms = Room.search(@organization.id, params[:phrase])
    @rooms -= @event.rooms
  end

  def search_available_items
    @items = Item.search(@organization.id, params[:phrase])
    @items -= @event.items
  end

  def find_busy(conflicting_events)
    busy_students = []
    busy_rooms = []
    busy_items = []

    conflicting_events.each do |event|
      busy_students << event.students
      busy_rooms << event.rooms
      busy_items << event.items
    end

    mark_busy(@students, busy_students) unless busy_students.empty?
    mark_busy(@rooms, busy_rooms) unless busy_rooms.empty?
    mark_busy(@items, busy_items) unless busy_items.empty?
  end

  def mark_busy(full_array, busy_array)
    busy_array.flatten!.uniq!
    full_array.each do |object|
      object.busy = busy_array.include?(object)
    end
  end
end
