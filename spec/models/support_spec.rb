# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Support, type: :model do
  context 'validation tests' do
    it 'should validates presence of email' do
      support = build(:support, email: nil).save
      expect(support).to eq(false)
    end

    it 'should validates presence of description' do
      support = build(:support, description: nil).save
      expect(support).to eq(false)
    end

    it 'should save support successfully' do
      support = create(:support)
      expect(support).to be_valid
    end
  end
end
