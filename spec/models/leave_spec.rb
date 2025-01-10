# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Leave, type: :model do
  let(:company) { create(:company) }
  let(:user) { create(:user, company:) }
  let(:apply_leave) { build(:apply_leave, company_id: company, allowed_leave_type: 'annual') }
  let(:leave) { build(:leave, user:, apply_leave:, company:) }
  let(:apply_leave_short) { create(:apply_leave, allowed_leave_type: 'short', company:) }
  let(:leave_short) { build(:leave, user:, apply_leave: apply_leave_short, company:) }

  context 'validation tests' do
    it 'should validates presence of date from' do
      leave = build(:leave, date_from: nil).save
      expect(leave).to eq(false)
    end
    it 'should validates presence of date to' do
      leave = build(:leave, date_to: nil).save
      expect(leave).to eq(false)
    end
    it 'should successfully save short leave' do
      leave = create(:leave, :short_leave)
      expect(leave).to be_valid
    end
    it 'should not accept start date less than from end date' do
      leave = build(:leave, date_from: Date.today + 1, date_to: Date.today).save
      expect(leave).to eq(false)
    end
    it 'should not accept start date less than from today' do
      leave = build(:leave, date_from: Date.today - 1).save
      expect(leave).to eq(false)
    end
    it 'should accept start date less than from end date' do
      leave = create(:leave)
      expect(leave.date_from).to be < leave.date_to
    end
    it 'should successfully save leave other than short' do
      leave = create(:leave)
      expect(leave).to be_valid
    end
  end
  context 'scope tests' do
    it 'should return leaves with status' do
      leave = create(:leave)
      expect(Leave.selected_leaves('pending')).to include(leave)
    end
    it "should return today's leave" do
      leave = create(:leave)
      expect(Leave.today).to include(leave)
    end
    it 'should return leave of leave type' do
      leave = create(:leave)
      expect(Leave.selected_type(leave.apply_leave_id)).to include(leave)
    end
  end
  context 'method tests' do
    it 'should allow leaves for allowed days' do
      leave = create(:leave)
      res = leave.leave_type_normal
      expect(res).to eq(true)
    end
    it 'should not accept leaves greater than allowed leaves' do
      leave = create(:leave, date_from: Date.today, date_to: Date.today + 30)
      expect(leave.leave_type_normal).to eq(false)
    end
    it 'should not check short leave' do
      short_leave = create(:leave, :short_leave)
      expect(short_leave.leave_type_normal).to eq(true)
    end
  end
  context 'when dates are present' do
    it 'returns true and sets request_leaves if there are enough available leaves' do
      create(:leave, user:, apply_leave:, request_leaves: Faker::Number.within(range: 1..4),
                     status: 'approved', company:)
      leave.date_from = Date.today
      leave.date_to = Date.today + 3.days
      expect(leave.leave_type_normal).to be_truthy
      expect(leave.request_leaves).to eq(4)
    end
    it 'returns false if there are not enough available leaves' do
      create(:leave, user:, apply_leave:, request_leaves: Faker::Number.within(range: 20..30),
                     status: 'approved', company:)
      leave.date_from = Date.today
      leave.date_to = Date.today + 4.days
      expect(leave.leave_type_normal).to be_falsy
    end
  end
  context 'when dates are not present' do
    it 'returns true' do
      expect(leave.leave_type_normal).to be_truthy
    end
  end
  context 'for short leave' do
    it 'adds an error to date_to' do
      leave_short.date_from = Date.today
      leave_short.date_to = Date.today + 1.day
      leave_short.dates_match_for_short_leave
      expect(leave_short.errors[:date_to]).to include('and Date From must be the same for short leave.')
    end
  end
  context 'when allowed_leave_type is not short' do
    it 'validates date_from less than or equal to date_to and greater than or equal to Date.today' do
      leave.date_from = Date.today
      leave.date_to = Date.today + 5.days
      expect(leave).to be_valid
    end
    it 'validates date_to greater than or equal to Date.today' do
      leave.date_from = Date.today - 2.days
      leave.date_to = Date.today
      expect(leave).not_to be_valid
    end
    it 'adds an error if date_from is greater than date_to' do
      leave.date_from = Date.today + 5.days
      leave.date_to = Date.today
      expect(leave).not_to be_valid
    end
    it 'adds an error if date_from is less than Date.today' do
      leave.date_from = Date.today - 2.days
      leave.date_to = Date.today + 5.days
      expect(leave).not_to be_valid
    end
    it 'adds an error if date_to is less than Date.today' do
      leave.date_from = Date.today
      leave.date_to = Date.today - 2.days
      expect(leave).not_to be_valid
    end
  end
end
