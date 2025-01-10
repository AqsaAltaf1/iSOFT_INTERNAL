# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      role = build(:role, name: '').save
      expect(role).to eq(false)
    end

    it 'validates presence of at least one permission' do
      role = Role.new(name: Faker::Name.name)
      role.valid?
      expect(role.errors[:base]).to include('At least one permission is required')
    end
  end

  describe 'callbacks' do
    it 'normalizes name before validation' do
      role = Role.new(name: 'any name')
      role.valid?
      expect(role.name).to eq('any_name')
    end

    it 'assigns permissions from input before validation on create' do
      permission = FactoryBot.create(:permission)
      role = Role.new(name: Faker::Name.name, permission_ids_input: [permission.id])
      role.valid?
      expect(role.permissions).to include(permission)
    end
  end
end
