require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:organization) do
    Organization.create!(
      title: "University",
      subdomain: "uni"
    )
  end
  let(:instructor) do
    User.create!(
      first_name: "Keith",
      last_name: "Conroy",
      email: "keith@mail.com",
      organization_id: organization.id,
      is_student: false,
    )
  end
  let(:student) do
    User.create!(
      first_name: "Test",
      last_name: "Student",
      email: "student@mail.com",
      organization_id: organization.id,
      is_student: true,
    )
  end
  let(:course) do
    Course.create!(
      title: "Test Course",
      instructor_id: instructor.id,
      organization_id: organization.id,
    )
  end
  let(:room) do
    Room.create!(
      title: "Test Room",
      organization_id: organization.id,
    )
  end
  let(:item) do
    Item.create!(
      title: "Test Item",
      quantity: 1,
      organization_id: organization.id,
    )
  end
  let(:event) do
    Event.create!(
      title: "Test Event",
      instructor_id: instructor.id,
      organization_id: organization.id,
    )
  end
  context 'GET index' do
    before { get :index, organization_id: organization.id }
    it "should get index" do
      response.should be_ok
    end
    it "gets events" do
      assigns(:events).should be_a(ActiveRecord::Relation)
    end
    it "assigns a event" do
      assigns(:new_event).should be_a(Event)
    end
  end

  context "POST create" do
    it "saves a new event and redirects" do
      expect{ post :create, event: {title: "Event", instructor_id: instructor.id, organization_id: organization.id}, organization_id: organization.id }.to change{Event.count}.by 1
      response.status.should eq 302
    end
    it "does not saves a new event with invalid input" do
      expect{ post :create, event: {title: ""}, organization_id: organization.id }.to_not change{Event.count}
    end
  end

  context "GET #show" do
    before { get :show, organization_id: organization.id, id: event.id }
    it "gets event" do
      assigns(:event).should be_a(Event)
    end
    # it "assigns students" do
    #   assigns(:students).should be_a(ActiveRecord::Relation)
    # end
    # it "assigns student" do
    #   assigns(:student).should be_a(User)
    # end
  end

  context "GET #edit" do
    before { get :edit, organization_id: organization.id, id: event.id }
    it "gets event" do
      assigns(:event).should be_a(Event)
    end
  end

  context "PUT #update" do
    context "valid update" do
      before { put :update, organization_id: organization.id, id: event.id, event: {title: "Updated Event"} }
      it "gets event" do
        assigns(:event).should be_a(Event)
      end
      it "updates the event" do
        Event.first.title.should match(/Updated Event/)
      end
      it "should redirect" do
        response.status.should eq 302
      end
    end

    context "invalid update" do
      before { put :update, organization_id: organization.id, id: event.id, event: {title: ""} }
      it "should not update" do
        Event.first.title.should match(//)
      end
      it "should give an error status" do
        response.status.should eq 400
      end
    end
  end

  context "DELETE #destroy" do
    before { delete :destroy, organization_id: organization.id, id: event.id }
    it "gets event" do
      assigns(:event).should be_a(Event)
    end
    it "destroys the event" do
      Event.count.should eq 0
    end
    it "should redirect" do
      response.status.should eq 302
    end
  end

  context "POST #add_course" do
    before { post :add_course, organization_id: organization.id, event_id: event.id, id: course.id }
    it "gets event" do
      assigns(:event).should be_a(Event)
    end
    it "gets course" do
      assigns(:course).should be_a(Course)
    end
    xit "assigns the courses students to the event" do
      Event.first.students.should include(course.students)
    end
  end

  context "POST #add_student" do
    before { post :add_student, organization_id: organization.id, event_id: event.id, id: student.id }
    it "gets event" do
      assigns(:event).should be_a(Event)
    end
    it "gets student" do
      assigns(:student).should be_a(User)
    end
    it "assigns the student to the event" do
      Event.first.students.should include(student)
    end
  end

  context "DELETE #remove_student" do
    before { post :add_student, organization_id: organization.id, event_id: event.id, id: student.id }
    before { post :remove_student, organization_id: organization.id, event_id: event.id, id: student.id }
    it "gets event" do
      assigns(:event).should be_a(Event)
    end
    it "gets student" do
      assigns(:student).should be_a(User)
    end
    it "assigns the student to the event" do
      Event.first.students.should_not include(student)
    end
  end

  context "POST #add_room" do
    before { post :add_room, organization_id: organization.id, event_id: event.id, id: room.id }
    it "gets event" do
      assigns(:event).should be_a(Event)
    end
    it "gets room" do
      assigns(:room).should be_a(Room)
    end
    it "assigns the room to the event" do
      Event.first.rooms.should include(room)
    end
  end

  context "DELETE #remove_room" do
    before { post :add_room, organization_id: organization.id, event_id: event.id, id: room.id }
    before { post :remove_room, organization_id: organization.id, event_id: event.id, id: room.id }
    it "gets event" do
      assigns(:event).should be_a(Event)
    end
    it "gets room" do
      assigns(:room).should be_a(Room)
    end
    it "assigns the room to the event" do
      Event.first.rooms.should_not include(room)
    end
  end

  context "POST #add_item" do
    before { post :add_item, organization_id: organization.id, event_id: event.id, id: item.id }
    it "gets event" do
      assigns(:event).should be_a(Event)
    end
    it "gets item" do
      assigns(:item).should be_a(Item)
    end
    it "assigns the item to the event" do
      Event.first.items.should include(item)
    end
  end

  context "DELETE #remove_item" do
    before { post :add_item, organization_id: organization.id, event_id: event.id, id: item.id }
    before { post :remove_item, organization_id: organization.id, event_id: event.id, id: item.id }
    it "gets event" do
      assigns(:event).should be_a(Event)
    end
    it "gets item" do
      assigns(:item).should be_a(Item)
    end
    it "assigns the item to the event" do
      Event.first.items.should_not include(item)
    end
  end

  context "GET #search" do
    before { get :search, organization_id: organization.id, phrase: 'event' }
  end

  context "GET #modify_search" do
    before { get :modify_search, organization_id: organization.id, event_id: event.id, phrase: 'event' }
  end
end

