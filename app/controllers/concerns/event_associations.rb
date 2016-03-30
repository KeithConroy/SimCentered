module EventAssociations
  extend ActiveSupport::Concern

  def add_course
    @event = find_event or return
    @course = Course.where(id: params[:course_id]).first

    if @course && @course.organization_id == @organization.id
      @event.courses << @course unless @event.courses.include?(@course)
      add_courses_students(@event, @course)
      if @event.save
        course_json = { title: @course.title, courseId: @course.id, eventId: @event.id }
        students_json = @course.students.map{ |student| get_student_json(student) }

        render json: {course: course_json, students: students_json}
      else
        render json: @event.errors.full_messages, status: 400
      end
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  def remove_course
    @event = find_event or return
    @course = Course.where(id: params[:course_id]).first

    if @event.courses.include?(@course)
      @event.courses.delete(@course)
      remove_courses_students(@event, @course)
      if @event.save
        render json: {
          count: @event.courses.count,
          courseId: @course.id,
          studentIds: @course.students.map {|student| student.id }
        }
      else
        render json: @event.errors.full_messages, status: 400
      end
    else
      render json: 'Course is not enrolled', status: 400
    end
  end

  def add_student
    @event = find_event or return
    @student = User.where(id: params[:student_id]).first

    if @student && @student.organization_id == @organization.id
      @event.students << @student unless @event.students.include?(@student)
      if @event.save
        render :'events/_scheduled_student', layout: false, locals: { student: @student }
      else
        render json: @event.errors.full_messages, status: 400
      end
    else
      render json: 'Invalid Student Association', status: 400
    end
  end

  def remove_student
    @event = find_event or return
    @student = User.where(id: params[:student_id]).first

    if @event.students.include?(@student)
      @event.students.delete(@student)
      if @event.save
        render json: {
          count: @event.students.count,
          studentId: @student.id
        }
      else
        render json: @event.errors.full_messages, status: 400
      end
    else
      render json: 'Student is not enrolled', status: 400
    end
  end

  def add_room
    @event = find_event or return
    @room = Room.where(id: params[:room_id]).first

    if @room && @room.organization_id == @organization.id
      @event.rooms << @room unless @event.rooms.include?(@room)
      if @event.save
        render :'events/_scheduled_room', layout: false, locals: { room: @room }
      else
        render json: @event.errors.full_messages, status: 400
      end
    else
      render json: 'Invalid Room Association', status: 400
    end
  end

  def remove_room
    @event = find_event or return
    @room = Room.where(id: params[:room_id]).first

    @event.rooms.delete(@room)
    if @event.save
      render json: {
        count: @event.rooms.count,
        roomId: @room.id
      }
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  def add_item
    @event = find_event or return
    @item = Item.where(id: params[:item_id]).first

    @event.items << @item
    if @event.save
      deduct_quantity(@event, @item) if @item.disposable
      render :'events/_scheduled_item', layout: false, locals: { item: @item }
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  def remove_item
    @event = find_event or return
    @item = Item.where(id: params[:item_id]).first

    quantity = @event.scheduled_items.where(item_id: @item.id).first.quantity
    @event.items.delete(@item)
    if @event.save
      credit_quantity(@item, quantity) if @item.disposable
      render json: {
        count: @event.items.count,
        itemId: @item.id
      }
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  private

  def get_student_json(student)
    { name: full_name(student), tudentId: student.id, eventId: @event.id }
  end

  def add_courses_students(event, course)
    course.students.each do |student|
      event.students << student unless event.students.include?(student)
    end
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