# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'validation tests' do
    it 'should validates presence of name' do
      project = build(:project, name: nil).save
      expect(project).to eq(false)
    end

    it 'should validates presence of description' do
      project = build(:project, description: nil).save
      expect(project).to eq(false)
    end

    it 'should save project successfully' do
      project = create(:project)
      expect(project).to be_valid
    end
  end
end
