# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  let(:company) { create(:company, status: 'active') }
  let(:user) { create(:user, company_id: company.id, status: 'active', user_type: 'user') }

  context 'validation tests' do
    it 'should validates presence of title' do
      evaluation = build(:evaluation, title: nil).save
      expect(evaluation).to eq(false)
    end

    it 'validates presence of at least one question' do
      evaluation = build(:evaluation, questions: []).save
      expect(evaluation).to eq(false)
    end

    it 'should create evaluation successfully' do
      evaluation = build(:evaluation, company_id: company.id, created_by: user.id, status: 'active')
      expect(evaluation).to be_valid
    end
  end
end
