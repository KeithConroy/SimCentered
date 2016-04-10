require 'rails_helper'

RSpec.describe "Authorization", type: :feature, :js => true do
  let(:organization){ create(:organization) }
  let(:student){ create(:student, organization_id: organization.id) }
  let(:student2){ create(:student2, organization_id: organization.id) }

  context 'student' do
    before do
      login_as(student, :scope => :user)
    end

    it 'does not show faculty nav' do
      visit("/organizations/1/users/#{student.id}")
      expect(page).to_not have_content 'Manage'
      expect(page).to_not have_content 'Pulse'
    end

    it 'blocks organization actions' do
      visit('/organizations/1')
      expect(page).to have_content 'You are not authorized to visit this page'
      visit('/organizations/1/edit')
      expect(page).to have_content 'You are not authorized to visit this page'
      visit('/organizations/new')
      expect(page).to have_content 'You are not authorized to visit this page'
    end

    it 'blocks event actions' do
      visit('/organizations/1/events')
      expect(page).to have_content 'You are not authorized to visit this page'
      visit('/organizations/1/events/1')
      expect(page).to have_content 'You are not authorized to visit this page'
      visit('/organizations/1/events/1/edit')
      expect(page).to have_content 'You are not authorized to visit this page'
    end

    it 'blocks course actions' do
      visit('/organizations/1/courses')
      expect(page).to have_content 'You are not authorized to visit this page'
      visit('/organizations/1/courses/1')
      expect(page).to have_content 'You are not authorized to visit this page'
      visit('/organizations/1/courses/1/edit')
      expect(page).to have_content 'You are not authorized to visit this page'
    end

    it 'blocks room actions' do
      visit('/organizations/1/rooms')
      expect(page).to have_content 'You are not authorized to visit this page'
      visit('/organizations/1/rooms/1')
      expect(page).to have_content 'You are not authorized to visit this page'
      visit('/organizations/1/rooms/1/edit')
      expect(page).to have_content 'You are not authorized to visit this page'
    end

    it 'blocks item actions' do
      visit('/organizations/1/items')
      expect(page).to have_content 'You are not authorized to visit this page'
      visit('/organizations/1/items/1')
      expect(page).to have_content 'You are not authorized to visit this page'
      visit('/organizations/1/items/1/edit')
      expect(page).to have_content 'You are not authorized to visit this page'
    end

    it 'blocks user actions' do
      visit("/organizations/1/users")
      expect(page).to have_content 'You are not authorized to visit this page'
      visit("/organizations/1/users/#{student2.id}")
      expect(page).to have_content 'You are not authorized to visit this page'
      visit("/organizations/1/users/#{student2.id}/edit")
      expect(page).to have_content 'You are not authorized to visit this page'
    end

    it 'allows student to view show and edit' do
      visit("/organizations/1/users/#{student.id}")
      expect(page).to have_content 'Test Student'
      expect(page).to have_content 'Courses'
      expect(page).to have_content 'Schedule'
      visit("/organizations/1/users/#{student.id}/edit")
      expect(page).to have_content 'Test Student'
      expect(page).to have_content 'Edit User'
    end

  end
end
