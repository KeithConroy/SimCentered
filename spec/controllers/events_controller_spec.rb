require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  login_admin

  let(:organization){ Organization.first }
  let(:other_organization){ create(:other_org) }

  let(:instructor){ create(:instructor, organization_id: organization.id) }
  let(:other_instructor){ create(:other_instructor, organization_id: other_organization.id) }
  let(:student){ create(:student, organization_id: organization.id) }
  let(:student2){ create(:student2, organization_id: organization.id) }
  let(:other_student){ create(:other_student, organization_id: other_organization.id) }

  let(:course){ create(:course, instructor_id: instructor.id, organization_id: organization.id)}
  let(:other_course){ create(:course, instructor_id: other_instructor.id, organization_id: other_organization.id)}

  let(:room){ create(:room, organization_id: organization.id)}
  let(:item){ create(:disposable_item, organization_id: organization.id) }
  let(:event){ create(:event, instructor_id: instructor.id, organization_id: organization.id) }

  context 'GET index' do
    before { get :index, organization_id: organization.id }
    it "should get index" do
      expect(response).to be_ok
      expect(response).to render_template("index")
    end
    it "gets events" do
      expect(assigns(:events)).to be_a(ActiveRecord::Relation)
    end
    it "calls Event.list" do
      expect(Event).to respond_to(:list).with(2).argument
    end
    it "assigns a event" do
      expect(assigns(:new_event)).to be_a(Event)
    end
  end

  context 'XHR index' do
    before { xhr :get, :index, organization_id: organization.id, start: DateTime.now, :end => DateTime.now}
    it "should get index" do
      expect(response).to be_ok
      expect(response.header['Content-Type']).to include('application/json')
    end
    it "calls Event.list_json" do
      expect(Event).to respond_to(:list_json).with(3).argument
    end
    it "gets calendar_events" do
      expect(assigns(:calendar_events)).to be_a(Array)
    end
    it "assigns a event" do
      expect(assigns(:new_event)).to be_a(Event)
    end
  end

  context 'GET new' do
    before { get :new, organization_id: organization.id }
    it "should get new" do
      expect(response).to be_ok
      expect(response).to render_template("new")
    end
    it "gets event" do
      expect(Event).to respond_to(:new)
      expect(assigns(:event)).to be_a(Event)
    end
  end

  context "POST create" do
    it "saves a new event and redirects" do
      expect{ post :create, event: {title: "Event", instructor_id: instructor.id, organization_id: organization.id}, organization_id: organization.id }.to change{Event.count}.by 1
      expect(response.status).to eq 302
    end
    it "belongs to instructor" do
      post :create, event: {title: "Event", instructor_id: instructor.id, organization_id: organization.id}, organization_id: organization.id
      expect(Event.last.instructor).to eq(instructor)
    end
    it "belongs to organization" do
      post :create, event: {title: "Event", instructor_id: instructor.id, organization_id: organization.id}, organization_id: organization.id
      expect(Event.last.organization_id).to eq(organization.id)
    end
    it "does not saves a new event with invalid input" do
      expect{ post :create, event: {title: ""}, organization_id: organization.id }.to_not change{Event.count}
    end
  end

  context "GET #show" do
    before { get :show, organization_id: organization.id, id: event.id }
    it "should get show" do
      expect(response).to be_ok
      expect(response).to render_template("show")
    end
    it "gets event" do
      expect(assigns(:event)).to be_a(Event)
    end
    it "renders 404 with invalid event" do
      get :show, organization_id: organization.id, id: 42
      expect(response.status).to eq 404
    end
  end

  context "GET #edit" do
    before { get :edit, organization_id: organization.id, id: event.id }
    it "gets event" do
      expect(assigns(:event)).to be_a(Event)
    end
    it "renders 404 with invalid event" do
      get :edit, organization_id: organization.id, id: 42
      expect(response.status).to eq 404
    end
  end

  context "PUT #update" do
    context "valid update" do
      before { put :update, organization_id: organization.id, id: event.id, event: {title: "Updated Event"} }
      it "gets event" do
        expect(assigns(:event)).to be_a(Event)
      end
      it "updates the event" do
        expect(Event.first.title).to match(/Updated Event/)
      end
      it "should redirect" do
        expect(response.status).to eq 302
      end
    end

    context "invalid update" do
      before { put :update, organization_id: organization.id, id: event.id, event: {title: ""} }
      it "should not update" do
        expect(Event.first.title).to match(//)
      end
      it "should give an error status" do
        expect(response.status).to eq 400
      end
      it "will not update organization_id" do
        put :update, organization_id: organization.id, id: event.id, event: {organization_id: other_organization.id}
        expect(event.organization_id).to_not eq(other_organization.id)
      end
      it "renders 404 with invalid event" do
        put :update, organization_id: organization.id, id: 42, event: {title: "Updated Event"}
        expect(response.status).to eq 404
      end
    end
  end

  context "DELETE #destroy" do
    before { delete :destroy, organization_id: organization.id, id: event.id }
    it "gets event" do
      expect(assigns(:event)).to be_a(Event)
    end
    it "destroys the event" do
      expect(Event.count).to eq 0
    end
    it "should redirect" do
      expect(response.status).to eq 302
    end
    it "renders 404 with invalid event" do
      get :show, organization_id: organization.id, id: 42
      expect(response.status).to eq 404
    end
  end

  context "POST #add_course" do
    context "valid #add_course" do
      before { course.students << student}
      before { course.students << student2}
      before { post :add_course, organization_id: organization.id, id: event.id, course_id: course.id }
      it "gets event" do
        expect(assigns(:event)).to be_a(Event)
      end
      it "gets course" do
        expect(assigns(:course)).to be_a(Course)
      end
      it "assigns the course to the event" do
        expect(Event.first.courses).to include(course)
        expect(course.events).to include(Event.first)
      end
      it "assigns the courses students to the event" do
        expect(Event.first.students).to include(student)
        expect(Event.first.students).to include(student2)
      end
    end

    context "invalid #add_course" do
      before { other_course.students << other_student }
      before { post :add_course, organization_id: organization.id, id: event.id, course_id: other_course.id }
      it "should give an error status" do
        expect(response.status).to eq 400
      end
      it "does not assign a course to the event" do
        expect(event.courses.count).to be(0)
        expect(event.courses).to_not include(other_course)
      end
      it "does not assign course's students to the event" do
        expect(event.students.count).to be(0)
        expect(event.students).to_not include(other_student)
      end
      it "renders 404 with invalid event" do
        post :add_course, organization_id: organization.id, id: 42, course_id: course.id
        expect(response.status).to eq 404
      end
    end
  end

  context "POST #add_student" do
    context "valid #add_student" do
      before { post :add_student, organization_id: organization.id, id: event.id, student_id: student.id }
      it "gets event" do
        expect(assigns(:event)).to be_a(Event)
      end
      it "gets student" do
        expect(assigns(:student)).to be_a(User)
      end
      it "assigns the student to the event" do
        expect(Event.first.students).to include(student)
      end
    end

    context "invalid #add_student" do
      context "student from another organization" do
        before { post :add_student, organization_id: organization.id, id: event.id, student_id: other_student.id }
        it "should give an error status" do
          expect(response.status).to eq 400
        end
        it "does not assign a student to the event" do
          expect(Event.first.students).to_not include(other_student)
        end
      end
      context "non existant student" do
        before { post :add_student, organization_id: organization.id, id: event.id, student_id: 20 }
        it "should give an error status" do
          expect(response.status).to eq 400
        end
        it "does not assign a student to the event" do
          expect(Event.first.students.count).to be(0)
        end
      end
      it "renders 404 with invalid event" do
        post :add_course, organization_id: organization.id, id: 42, student_id: student.id
        expect(response.status).to eq 404
      end
    end
  end

  context "DELETE #remove_student" do
    before { post :add_student, organization_id: organization.id, id: event.id, student_id: student.id }
    before { post :remove_student, organization_id: organization.id, id: event.id, student_id: student.id }
    it "gets event" do
      expect(assigns(:event)).to be_a(Event)
    end
    it "gets student" do
      expect(assigns(:student)).to be_a(User)
    end
    it "removes the student from the event" do
      expect(Event.first.students).to_not include(student)
    end
  end

  context "POST #add_room" do
    before { post :add_room, organization_id: organization.id, id: event.id, room_id: room.id }
    it "gets event" do
      expect(assigns(:event)).to be_a(Event)
    end
    it "gets room" do
      expect(assigns(:room)).to be_a(Room)
    end
    it "assigns the room to the event" do
      expect(Event.first.rooms).to include(room)
    end
  end

  context "DELETE #remove_room" do
    before { post :add_room, organization_id: organization.id, id: event.id, room_id: room.id }
    before { post :remove_room, organization_id: organization.id, id: event.id, room_id: room.id }
    it "gets event" do
      expect(assigns(:event)).to be_a(Event)
    end
    it "gets room" do
      expect(assigns(:room)).to be_a(Room)
    end
    it "removes the room from the event" do
      expect(Event.first.rooms).to_not include(room)
    end
  end

  context "POST #add_item" do
    before { post :add_item, organization_id: organization.id, id: event.id, item_id: item.id, quantity: 1 }
    it "gets event" do
      expect(assigns(:event)).to be_a(Event)
    end
    it "gets item" do
      expect(assigns(:item)).to be_a(Item)
    end
    it "assigns the item to the event" do
      expect(Event.first.items).to include(item)
    end
    it "deducts the scheduled quantity from item quantity" do
      expect(Event.first.items.first.quantity).to eq(99)
    end
    it "sets the scheduled_items quantity" do
      expect(Event.first.scheduled_items.first.quantity).to eq(1)
    end
  end

  context "DELETE #remove_item" do
    before { post :add_item, organization_id: organization.id, id: event.id, item_id: item.id, quantity: 1 }
    before { post :remove_item, organization_id: organization.id, id: event.id, item_id: item.id }
    it "gets event" do
      expect(assigns(:event)).to be_a(Event)
    end
    it "gets item" do
      expect(assigns(:item)).to be_a(Item)
    end
    it "removes the item from the event" do
      expect(Event.first.items).to_not include(item)
    end
    it "credits the scheduled quantity to item quantity" do
      expect(item.quantity).to eq(100)
    end
  end

  context "GET #search" do
    before { post :create, event: {title: "Event", instructor_id: instructor.id, organization_id: organization.id}, organization_id: organization.id }
    before { post :create, event: {title: "Session", instructor_id: instructor.id, organization_id: organization.id}, organization_id: organization.id }
    before { post :create, event: {title: "Party", instructor_id: instructor.id, organization_id: organization.id}, organization_id: organization.id }

    context 'valid search: full title match' do
      before { get :search, organization_id: organization.id, phrase: 'event' }
      it "calls Event.search" do
        expect(Event).to respond_to(:search).with(2).argument
      end
      it "gets events" do
        expect(assigns(:events)).to be_a(ActiveRecord::Relation)
      end
      it "finds a match" do
        expect(assigns(:events)).not_to be_empty
        expect(assigns(:events).length).to eq(1)
        expect(assigns(:events).first.title).to eq("Event")
      end
    end
    context 'valid search: partial match' do
      before { get :search, organization_id: organization.id, phrase: 'e' }
      it "finds two matches" do
        expect(assigns(:events).length).to eq(2)
        expect(assigns(:events).first.title).to eq("Event")
        expect(assigns(:events).last.title).to eq("Session")
      end
    end
    context 'invalid search' do
      before { get :search, organization_id: organization.id, phrase: 'abc' }
      it "returns empty" do
        expect(assigns(:events)).to be_empty
      end
    end
    context 'empty search' do
      before { get :search, organization_id: organization.id }
      it "gets all events" do
        expect(assigns(:events).length).to eq(3)
      end
    end
  end

  context "GET #modify_search" do
    before { get :modify_search, organization_id: organization.id, id: event.id, phrase: 'event' }
    it 'gets appropriate response' do
      expect(response).to be_ok
      expect(response).to render_template("events/_modify_search")
    end
    it 'calls Event.conflicting' do
      expect(Event).to respond_to(:conflicting).with(2).argument
    end
    it 'calls Course.search' do
      expect(Course).to respond_to(:search).with(2).argument
      expect(assigns(:courses)).to be_a(Array)
    end
    it 'calls User.search_students' do
      expect(User).to respond_to(:search_students).with(2).argument
      expect(assigns(:students)).to be_a(Array)
    end
    it 'calls Room.search' do
      expect(Room).to respond_to(:search).with(2).argument
      expect(assigns(:rooms)).to be_a(Array)
    end
    it 'calls Item.search' do
      expect(Item).to respond_to(:search).with(2).argument
      expect(assigns(:items)).to be_a(Array)
    end
    it "renders 404 with invalid event" do
      get :modify_search, organization_id: organization.id, id: 42, phrase: 'event'
      expect(response.status).to eq 404
    end
  end
end

