module EventAssociations
  extend ActiveSupport::Concern

  def add_course
    @event = find_event || return
    @course = Course.where(id: params[:course_id]).first

    begin
      @event.courses << @course
      course_json = { title: @course.title, courseId: @course.id, eventId: @event.id }
      students_json = @course.students.map { |student| get_student_json(student) }

      render json: { course: course_json, students: students_json }
    rescue => e
      render json: { error: e }, status: 400
    end
  end

  def remove_course
    @event = find_event || return
    @course = Course.where(id: params[:course_id]).first

    @event.courses.delete(@course)
    render json: {
      count: @event.courses.count,
      courseId: @course.id,
      studentIds: @course.students.map(&:id)
    }
  end

  def add_student
    @event = find_event || return
    @student = User.where(id: params[:student_id]).first

    begin
      @event.students << @student
      render :'events/_scheduled_student', layout: false, locals: { student: @student }
    rescue => e
      render json: { error: e }, status: 400
    end
  end

  def remove_student
    @event = find_event || return
    @student = User.where(id: params[:student_id]).first

    @event.students.delete(@student)
    render json: { count: @event.students.count, studentId: @student.id }
  end

  def add_room
    @event = find_event || return
    @room = Room.where(id: params[:room_id]).first

    begin
      @event.rooms << @room
      render :'events/_scheduled_room', layout: false, locals: { room: @room }
    rescue => e
      puts e
      # render json: 'Invalid Room Association', status: 400
    end
  end

  def remove_room
    @event = find_event || return
    @room = Room.where(id: params[:room_id]).first

    @event.rooms.delete(@room)
    render json: {
      count: @event.rooms.count,
      roomId: @room.id
    }
  end

  def add_item
    @event = find_event || return
    @item = Item.where(id: params[:item_id]).first

    begin
      @event.items << @item
      deduct_quantity(@event, @item) if @item.disposable
      render :'events/_scheduled_item', layout: false, locals: { item: @item }
    rescue => e
      puts e
      # render json: @event.errors.full_messages, status: 400
    end
  end

  def remove_item
    @event = find_event || return
    @item = Item.where(id: params[:item_id]).first

    quantity = @event.scheduled_items.where(item_id: @item.id).first.quantity
    @event.items.delete(@item)
    credit_quantity(@item, quantity) if @item.disposable
    render json: { count: @event.items.count, itemId: @item.id }
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
