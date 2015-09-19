require 'rails_helper'

RSpec.describe Course, type: :model do
  it "fails validation with no title (using error_on)" do
    # expect(Course.new).to have(1).error_on(:title)
    # expect(Course).to validate_presence_of(:title)
  end
end
