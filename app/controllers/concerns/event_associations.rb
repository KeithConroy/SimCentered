module EventAssociations
  extend ActiveSupport::Concern

  def add_course
    begin
      @event = find_event
      @course = Course.where(id: params[:course_id]).first

      @event.courses << @course
      course_json = { title: @course.title, courseId: @course.id, eventId: @event.id }
      students_json = @course.students.map { |student| get_student_json(student) }

      render json: { course: course_json, students: students_json }
    rescue => e
      render json: { error: e }, status: 400
    end
  end

  def remove_course
    begin
      @event = find_event
      @course = Course.where(id: params[:course_id]).first

      @event.courses.delete(@course)
      render json: {
        count: @event.courses.count,
        courseId: @course.id,
        studentIds: @course.students.map(&:id)
      }
    rescue => e
      render json: { error: e }, status: 400
    end
  end

  def add_student
    begin
      @event = find_event
      @student = User.where(id: params[:student_id]).first

      @event.students << @student
      render :'events/_scheduled_student', layout: false, locals: { student: @student }
    rescue => e
      render json: { error: e }, status: 400
    end
  end

  def remove_student
    begin
      @event = find_event
      @student = User.where(id: params[:student_id]).first

      @event.students.delete(@student)
      render json: { count: @event.students.count, studentId: @student.id }
    rescue => e
      render json: { error: e }, status: 400
    end
  end

  def add_room
    begin
      @event = find_event
      @room = Room.where(id: params[:room_id]).first

      @event.rooms << @room
      render :'events/_scheduled_room', layout: false, locals: { room: @room }
    rescue => e
      render json: { error: e }, status: 400
    end
  end

  def remove_room
    begin
      @event = find_event
      @room = Room.where(id: params[:room_id]).first

      @event.rooms.delete(@room)
      render json: {
        count: @event.rooms.count,
        roomId: @room.id
      }
    rescue => e
      render json: { error: e }, status: 400
    end
  end

  def add_item
    begin
      @event = find_event
      @item = Item.where(id: params[:item_id]).first

      @event.items << @item
      deduct_quantity(@event, @item) if @item.disposable
      render :'events/_scheduled_item', layout: false, locals: { item: @item }
    rescue => e
      render json: { error: e }, status: 400
    end
  end

  def remove_item
    begin
      @event = find_event
      @item = Item.where(id: params[:item_id]).first

      quantity = @event.scheduled_items.where(item_id: @item.id).first.quantity
      @event.items.delete(@item)
      credit_quantity(@item, quantity) if @item.disposable
      render json: { count: @event.items.count, itemId: @item.id }
    rescue => e
      render json: { error: e }, status: 400
    end
  end

  private

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
