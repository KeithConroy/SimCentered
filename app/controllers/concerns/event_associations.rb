module EventAssociations
  extend ActiveSupport::Concern

  def add_course
    @event = find_event
    @course = find_course

    @event.courses << @course unless @event.courses.include?(@course)
    course_json = { title: @course.title, courseId: @course.id, eventId: @event.id }
    students_json = @course.students.map { |student| get_student_json(student) }

    render json: { course: course_json, students: students_json }
  end

  def remove_course
    @event = find_event
    @course = find_course

    @event.courses.delete(@course)
    render json: {
      count: @event.courses.count,
      courseId: @course.id,
      studentIds: @course.students.map(&:id)
    }
  end

  def add_student
    @event = find_event
    @student = find_student

    @event.students << @student unless @event.student.include?(@student)
    render :'events/_scheduled_student', layout: false, locals: { student: @student }
  end

  def remove_student
    @event = find_event
    @student = find_student

    @event.students.delete(@student)
    render json: { count: @event.students.count, studentId: @student.id }
  end

  def add_room
    @event = find_event
    @room = find_room

    @event.rooms << @room unless @event.rooms.include?(@room)
    render :'events/_scheduled_room', layout: false, locals: { room: @room }
  end

  def remove_room
    @event = find_event
    @room = find_room

    @event.rooms.delete(@room)
    render json: {
      count: @event.rooms.count,
      roomId: @room.id
    }
  end

  def add_item
    @event = find_event
    @item = find_item

    @event.items << @item unless @event.items.include?(@item)
    deduct_quantity(@event, @item) if @item.disposable
    render :'events/_scheduled_item', layout: false, locals: { item: @item }
  end

  def remove_item
    @event = find_event
    @item = find_item

    quantity = @event.scheduled_items.where(item_id: @item.id).first.quantity
    @event.items.delete(@item)
    credit_quantity(@item, quantity) if @item.disposable
    render json: { count: @event.items.count, itemId: @item.id }
  end

  private

  def find_course
    authorize_resource(Course.where(id: params[:course_id]).first)
  end

  def find_student
    authorize_resource(User.where(id: params[:student_id]).first)
  end

  def find_item
    authorize_resource(Item.where(id: params[:item_id]).first)
  end

  def find_room
    authorize_resource(Room.where(id: params[:room_id]).first)
  end

  def get_student_json(student)
    { name: full_name(student), tudentId: student.id, eventId: @event.id }
  end

  def remove_courses_students(event, course)
    course.students.each do |student|
      event.students.delete(student)
    end
  end

  def deduct_quantity(event, item)
    scheduled_item = event.scheduled_items.where(item_id: item.id).first
    scheduled_item.quantity = params[:quantity]
    scheduled_item.save
    item.quantity -= scheduled_item.quantity
    item.save
  end

  def credit_quantity(item, credit)
    item.quantity += credit
    item.save
  end
end
