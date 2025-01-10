# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplyLeave, type: :model do
  let(:company) { create(:company) }
  let(:user) { create(:user, company:) }
  context 'validation tests' do
    it 'should validates presence of allowed leave type' do
      apply_leave = build(:apply_leave, allowed_leave_type: nil).save
      expect(apply_leave).to eq(false)
    end

    it 'should validates presence of allowed days' do
      apply_leave = build(:apply_leave, allowed_day: nil).save
      expect(apply_leave).to eq(false)
    end

    it 'should save apply leave successfully' do
      apply_leave = create(:apply_leave)
      expect(apply_leave).to be_valid
    end
  end

  context 'remaining_leaves_of_type' do
    it 'calculates remaining leaves of a specific type for a user' do
      apply_leave = create(:apply_leave, company:, allowed_leave_type: Faker::Name.name,
                                         allowed_day: Faker::Number.within(range: 10..15))
      create(:leave, user:, apply_leave:, request_leaves: Faker::Number.within(range: 1..4),
                     status: 'approved')
      create(:leave, user:, apply_leave:, request_leaves: Faker::Number.within(range: 1..2),
                     status: 'approved')
      create(:leave, user:, apply_leave:, request_leaves: Faker::Number.within(range: 1..4),
                     status: 'pending')
      create(:leave, user:, apply_leave:, request_leaves: Faker::Number.within(range: 1..2),
                     status: 'approved')
      remaining_leaves = ApplyLeave.remaining_leaves_of_type(apply_leave.id, user)
      expect(remaining_leaves).to eq(remaining_leaves)
    end
  end
end
