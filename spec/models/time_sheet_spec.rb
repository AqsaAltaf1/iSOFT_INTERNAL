# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeSheet, type: :model do
  describe 'validations' do
    context 'when creating a new time sheet' do
      let(:company) { create(:company) }
      let(:user) { create(:user, company:) }
      let(:project) { create(:project, company:) }
      let(:valid_time_sheet) { build(:time_sheet, company:, project:, user:) }

      it 'is valid with valid attributes' do
        expect(valid_time_sheet).to be_valid
      end

      it 'is invalid if time is not greater than zero' do
        invalid_time_sheet = build(:time_sheet, company:, project:, user:,
                                                time: Time.zone.parse('00:00'))
        expect(invalid_time_sheet).not_to be_valid
        expect(invalid_time_sheet.errors[:base]).to include('Time must be greater than zero')
      end

      it 'is invalid if the date is in the future' do
        future_date = Date.today + 1.day
        time_sheet = build(:time_sheet, company:, project:, user:, date: future_date)
        expect(time_sheet).not_to be_valid
        expect(time_sheet.errors[:base]).to include('You cannot create Timesheet for coming days')
      end

      it 'is invalid if the date is not in the current week' do
        past_date = Date.today - 8.days
        time_sheet = build(:time_sheet, company:, project:, user:, date: past_date)
        expect(time_sheet).not_to be_valid
        expect(time_sheet.errors[:base]).to include('You can only create Timesheet in current week')
      end

      it 'is valid if the date is in the current week' do
        current_week_date = Date.today - 2.days
        time_sheet = build(:time_sheet, company:, user:, project:, date: current_week_date)
        expect(time_sheet).to be_valid
      end
    end
  end
end
