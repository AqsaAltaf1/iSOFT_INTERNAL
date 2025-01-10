# frozen_string_literal: true

require 'rails_helper'

RSpec.describe History, type: :model do
  let(:company) { create(:company, status: 'active') }
  let(:user) { create(:user, status: 'active', user_type: 'admin') }
  let(:company_asset) { create(:company_asset, status: 'available', company_id: company.id, user_id: user.id) }

  describe 'validations' do
    it 'should validates presence of given_date ' do
      history = build(:history, given_date: nil).save
      expect(history).to eq(false)
    end

    it 'should validates presence of return_date ' do
      history = build(:history, return_date: nil, company_asset_id: company_asset, user_id: user,
                                company_id: company.id).save
      expect(history).to eq(false)
    end

    it 'should save history successfully' do
      history = create(:history, company_asset_id: company_asset.id, user_id: user.id, company_id: company.id)
      expect(history).to be_valid
    end
  end
end
