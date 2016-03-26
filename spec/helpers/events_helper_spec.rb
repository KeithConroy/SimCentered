require 'rails_helper'

describe EventsHelper do
  let(:organization){ create(:organization) }
  let(:instructor){ create(:instructor, organization_id: organization.id) }
  let(:hour_event){ create(:event, instructor_id: instructor.id, organization_id: organization.id) }
  let(:two_hour_event){ create(:event, instructor_id: instructor.id, organization_id: organization.id, start: DateTime.now, finish: DateTime.now + 120.minutes) }
  let(:half_hour_event){ create(:event, instructor_id: instructor.id, organization_id: organization.id, start: DateTime.now, finish: DateTime.now + 30.minutes) }

  describe "#event_duration" do
    it "returns the event duration" do
      expect(event_duration(hour_event)).to eq(1)
      expect(event_duration(two_hour_event)).to eq(2)
      expect(event_duration(half_hour_event)).to eq(0.5)
    end
  end
end