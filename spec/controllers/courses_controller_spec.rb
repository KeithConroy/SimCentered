require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  login_admin

  let(:organization){ Organization.first }
  let(:instructor){ create(:instructor, organization_id: organization.id) }
  let(:student){ create(:student, organization_id: organization.id) }
  let(:course){ create(:course, instructor_id: instructor.id, organization_id: organization.id)}

  context 'GET index' do
    before { get :index, organization_id: organization.id }
    it "should get index" do
      expect(response).to be_ok
      expect(response).to render_template("index")
    end
    it "gets courses" do
      expect(assigns(:courses)).to be_a(ActiveRecord::Relation)
    end
    it "assigns a course" do
      expect(assigns(:new_course)).to be_a(Course)
    end
  end

  context 'GET new' do
    before { get :new, organization_id: organization.id }
    it "should get new" do
      expect(response).to be_ok
      expect(response).to render_template("new")
    end
  end

  context "POST create" do
    it "saves a new course and redirects" do
      expect{ post :create, course: {title: "Course", instructor_id: instructor.id, organization_id: organization.id}, organization_id: organization.id }.to change{Course.count}.by 1
      expect(response.status).to eq 302
    end
    it "does not saves a new course with invalid input" do
      expect{ post :create, course: {title: ""}, organization_id: organization.id }.to_not change{Course.count}
    end
  end

  context "GET #show" do
    before { get :show, organization_id: organization.id, id: course.id }
    it "should get show" do
      expect(response).to be_ok
      expect(response).to render_template("show")
    end
    it "gets course" do
      expect(assigns(:course)).to be_a(Course)
    end
    it "renders 404 with invalid course" do
      get :show, organization_id: organization.id, id: 42
      expect(response.status).to eq 404
    end
  end

  context "GET #edit" do
    before { get :edit, organization_id: organization.id, id: course.id }
    it "gets course" do
      expect(assigns(:course)).to be_a(Course)
    end
    it "renders 404 with invalid course" do
      get :edit, organization_id: organization.id, id: 42
      expect(response.status).to eq 404
    end
  end

  context "PUT #update" do
    context "valid update" do
      before { put :update, organization_id: organization.id, id: course.id, course: {title: "Updated Course"} }
      it "gets course" do
        expect(assigns(:course)).to be_a(Course)
      end
      it "updates the course" do
        expect(Course.first.title).to match(/Updated Course/)
      end
      it "should redirect" do
        expect(response.status).to eq 302
      end
    end

    context "invalid update" do
      before { put :update, organization_id: organization.id, id: course.id, course: {title: ""} }
      it "should not update" do
        expect(Course.first.title).to match(//)
      end
      it "should give an error status" do
        expect(response.status).to eq 400
      end
      it "will not update organization_id" do
        put :update, organization_id: organization.id, id: course.id, course: {organization_id: 123}
        expect(course.organization_id).to_not eq(123)
      end
      it "renders 404 with invalid course" do
        put :update, organization_id: organization.id, id: 42, course: {title: "Updated Course"}
        expect(response.status).to eq 404
      end
    end
  end

  context "DELETE #destroy" do
    before { delete :destroy, organization_id: organization.id, id: course.id }
    it "gets course" do
      expect(assigns(:course)).to be_a(Course)
    end
    it "destroys the course" do
      expect(Course.count).to eq 0
    end
    it "should redirect" do
      expect(response.status).to eq 302
    end
    it "renders 404 with invalid course" do
      delete :destroy, organization_id: organization.id, id: 42
      expect(response.status).to eq 404
    end
  end

  context "POST #add_student" do
    context "valid #add_student" do
      before { post :add_student, organization_id: organization.id, id: course.id, student_id: student.id }
      it "gets course" do
        expect(assigns(:course)).to be_a(Course)
      end
      it "gets student" do
        expect(assigns(:student)).to be_a(User)
      end
      it "assigns the student to the course" do
        expect(Course.first.students).to include(student)
      end
    end
    context "invalid #add_student" do
      before { post :add_student, organization_id: organization.id, id: course.id, student_id: 42 }
      it "should give an error status" do
        expect(response.status).to eq 404
      end
      it "does not assign a student to the course" do
        expect(Course.first.students.count).to be(0)
      end
      it "renders 404 with invalid course" do
        post :add_student, organization_id: organization.id, id: 42, student_id: student.id
        expect(response.status).to eq 404
      end
    end
  end

  context "DELETE #remove_student" do
    context "valid #remove_student" do
      before { post :add_student, organization_id: organization.id, id: course.id, student_id: student.id }
      before { post :remove_student, organization_id: organization.id, id: course.id, student_id: student.id }
      it "gets course" do
        expect(assigns(:course)).to be_a(Course)
      end
      it "gets student" do
        expect(assigns(:student)).to be_a(User)
      end
      it "remove the student from the course" do
        expect(Course.first.students).to_not include(student)
      end
    end
    context "invalid #remove_student" do
      before { post :add_student, organization_id: organization.id, id: course.id, student_id: student.id }
      before { post :remove_student, organization_id: organization.id, id: course.id, student_id: 42 }
      it "should give an error status" do
        expect(response.status).to eq 404
      end
      it "does not remove a student from the course" do
        expect(Course.first.students.count).to be(1)
      end
      it "renders 404 with invalid course" do
        post :remove_student, organization_id: organization.id, id: 42, student_id: student.id
        expect(response.status).to eq 404
      end
    end
  end

  context "GET #search" do
    before { post :create, course: {title: "Course A"}, organization_id: organization.id }
    before { post :create, course: {title: "Course 101"}, organization_id: organization.id }
    before { post :create, course: {title: "Patient History"}, organization_id: organization.id }

    context 'valid search: full title match' do
      before { get :search, organization_id: organization.id, phrase: 'course a' }
      it "calls Course.search" do
        expect(Course).to respond_to(:search).with(2).argument
      end
      it "gets courses" do
        expect(assigns(:courses)).to be_a(ActiveRecord::Relation)
      end
      it "finds a match" do
        expect(assigns(:courses)).not_to be_empty
        expect(assigns(:courses).length).to eq(1)
        expect(assigns(:courses).first.title).to eq("Course A")
      end
    end
    context 'valid search: partial match' do
      before { get :search, organization_id: organization.id, phrase: 'course' }
      it "finds two matches" do
        expect(assigns(:courses).length).to eq(2)
        expect(assigns(:courses).first.title).to eq("Course 101")
        expect(assigns(:courses).last.title).to eq("Course A")
      end
    end
    context 'invalid search' do
      before { get :search, organization_id: organization.id, phrase: 'abc' }
      it "returns empty" do
        expect(assigns(:courses)).to be_empty
      end
    end
    context 'empty search' do
      before { get :search, organization_id: organization.id }
      it "gets all courses" do
        expect(assigns(:courses).length).to eq(3)
      end
    end
  end

  context "GET #modify_search" do
    before { get :modify_search, organization_id: organization.id, id: course.id, phrase: 'course' }
    it 'gets appropriate response' do
      expect(response).to be_ok
      expect(response).to render_template("courses/_modify_search")
    end
    it 'calls User.search_students' do
      expect(User).to respond_to(:search_students).with(2).argument
      expect(assigns(:students)).to be_a(Array)
    end
    it "renders 404 with invalid course" do
      get :modify_search, organization_id: organization.id, id: 42, phrase: 'course'
      expect(response.status).to eq 404
    end
  end
end
