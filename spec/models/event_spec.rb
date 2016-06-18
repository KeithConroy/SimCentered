require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:organization){ create(:organization) }
  let(:instructor){ create(:instructor, organization_id: organization.id) }
  let(:event){ create(:event, instructor_id: instructor.id, organization_id: organization.id) }
  let(:four_hour_event){ create(:event, instructor_id: instructor.id, organization_id: organization.id, start: DateTime.now, finish: DateTime.now + 4.hours) }

  context 'validation' do
    it "fails validation with no title" do
      event = Event.new(
        instructor_id: instructor.id,
        organization_id: organization.id,
      )
      event.valid?
      expect(event.errors[:title].size).to eq(1)
    end
    it "fails validation with no organization_id" do
      event = Event.new(
        title: "Test Event",
        instructor_id: instructor.id,
      )
      event.valid?
      expect(event.errors[:organization_id].size).to eq(1)
    end
  end

  context "#duration" do
    it "returns the events duration" do
      expect(event.duration).to eq(1)
      expect(four_hour_event.duration).to eq(4)
    end
  end
end
