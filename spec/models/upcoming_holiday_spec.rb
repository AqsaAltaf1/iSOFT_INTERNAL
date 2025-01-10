# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpcomingHoliday, type: :model do
  context 'validation tests' do
    it 'should validates presence of title' do
      upcoming_holiday = build(:upcoming_holiday, title: nil).save
      expect(upcoming_holiday).to eq(false)
    end

    it 'should validates presence of description' do
      upcoming_holiday = build(:upcoming_holiday, description: nil).save
      expect(upcoming_holiday).to eq(false)
    end

    it 'should validates presence of date' do
      upcoming_holiday = build(:upcoming_holiday, date: nil).save
      expect(upcoming_holiday).to eq(false)
    end

    it 'should not accept date less or equal than today' do
      upcoming_holiday = build(:upcoming_holiday, date: Date.today)
      expect(upcoming_holiday.valid?).to eq(false)
    end

    it 'should save support successfully' do
      upcoming_holiday = create(:upcoming_holiday)
      expect(upcoming_holiday).to be_valid
    end
  end
end
