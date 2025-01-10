# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'validation tests' do
    it 'should not save with nil name' do
      company = build(:company, name: nil).save
      expect(company).to eq(false)
    end

    it 'should not save with nil status' do
      company = build(:company, status: nil).save
      expect(company).to eq(false)
    end

    it 'should not save with nil subdomain' do
      company = build(:company, subdomain: nil).save
      expect(company).to eq(false)
    end

    it 'should save company successfully' do
      company = create(:company)
      expect(company).to be_valid
    end
  end

  describe 'logout_users_if_inactive' do
    let(:company) { create(:company, status: :pending) }
    it 'logs out active users if company status is inactive' do
      company.status = :inactive
      expect(company).to receive(:logout_active_users)
      company.logout_users_if_inactive
    end

    it 'logs out active users if company status is pending' do
      company.status = :pending
      expect(company).to receive(:logout_active_users)
      company.logout_users_if_inactive
    end

    it 'does not log out active users if company status is active' do
      company.status = :active
      expect(company).not_to receive(:logout_active_users)
      company.logout_users_if_inactive
    end
  end

  describe 'logout_active_users' do
    let(:company) { create(:company, status: :pending) }
    let(:another_company) { create(:company, status: :pending) }
    let(:active_user) { create(:user, company_id: company.id, status: 'active') }
    let(:user_from_another_company) { create(:user, company_id: another_company.id, status: 'active') }

    it 'changes status of active users belonging to the company to inactive' do
      company.logout_active_users
      active_user.reload
      expect(active_user.status).to eq('inactive')
    end

    it 'does not change status of users from other companies' do
      company.logout_active_users
      user_from_another_company.reload
      expect(user_from_another_company.status).to eq('active')
    end
  end
end
