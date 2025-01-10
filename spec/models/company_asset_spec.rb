# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyAsset, type: :model do
  context 'validation tests' do
    it 'should validates presence of name' do
      company_asset = build(:company_asset, name: nil).save
      expect(company_asset).to eq(false)
    end

    it 'should not save company asset for invalid type of file' do
      company_asset = build(:company_asset, :invalid_file).save
      expect(company_asset).to eq(false)
    end

    it 'should validates presence of unique identifier' do
      company_asset = build(:company_asset, unique_identifier: nil).save
      expect(company_asset).to eq(false)
    end

    it 'should save company asset successfully' do
      company_asset = create(:company_asset)
      expect(company_asset).to be_valid
    end
  end
end
