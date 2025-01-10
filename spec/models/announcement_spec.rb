# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Announcement, type: :model do
  it 'should validates title for announcement' do
    announcement = build(:announcement, title: nil).save
    expect(announcement).to eq(false)
  end
  it 'should validates body for announcement' do
    announcement = build(:announcement, body: nil).save
    expect(announcement).to eq(false)
  end
  it 'should successfully save announcement' do
    leave = create(:announcement)
    expect(leave).to be_valid
  end
end
