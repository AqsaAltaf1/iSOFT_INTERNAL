# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:company) { create(:company) }
  let(:role) { create(:role) }

  context 'validation tests' do
    it 'should validates presence of joining date ' do
      user = build(:user, joining_date: nil).save
      expect(user).to eq(false)
    end

    it 'should validates presence of role' do
      user = build(:user, role_id: nil).save
      expect(user).to eq(false)
    end

    it 'should validates presence of avatar' do
      user = build(:user, avatar: nil).save
      expect(user).to eq(false)
    end

    it 'is valid with a valid phone number format' do
      user = build(:user, phone_number: '00923451234567', role_id: role.id)
      expect(user).to be_valid
    end

    it 'is valid with a valid phone number format' do
      user = build(:user, phone_number: '923451234567', role_id: role.id)
      expect(user).to be_valid
    end

    it 'is valid with a valid phone number format' do
      user = build(:user, phone_number: '+923451234567', role_id: role.id)
      expect(user).to be_valid
    end

    it 'is valid with a valid phone number format' do
      user = build(:user, phone_number: '03451234567', role_id: role.id)
      expect(user).to be_valid
    end

    it 'is valid with a complex password' do
      user = build(:user, password: 'Abc12345')
      user.password_complexity

      expect(user.errors[:password]).to be_empty
    end

    it 'is not valid with a password lacking complexity' do
      user = build(:user, password: 'simplepassword')
      user.password_complexity

      expect(user.errors[:password]).to include('Complexity requirement not met. Please use: 1 uppercase, 1 lowercase and 1 digit')
    end

    it 'is valid with a valid image attachment' do
      user = build(:user)
      user.avatar.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'ISOFTSTUDIOS.png')),
                         filename: 'valid_image.png')
      user.custom_avatar_validation

      expect(user.errors[:avatar]).to be_empty
    end

    it 'is not valid with an invalid image attachment' do
      user = build(:user)
      user.avatar.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'no-image.zip')),
                         filename: 'invalid_image.txt')
      user.custom_avatar_validation

      expect(user.errors[:avatar]).to include('must be a valid image format (PNG, JPG, JPEG)')
    end
  end

  context 'validations for update action' do
    it 'is valid when updating with valid attributes' do
      user = create(:user)
      user.first_name = 'UpdatedName'
      expect(user).to be_valid
    end

    it 'is not valid when updating with invalid attributes' do
      user = create(:user)
      user.first_name = '123'
      expect(user).not_to be_valid
    end

    it 'is not valid when updating with invalid attributes' do
      user = create(:user)
      user.first_name = '123aqss'
      expect(user).not_to be_valid
    end

    it 'is not valid when updating with invalid attributes' do
      user = create(:user)
      user.first_name = '$aqss'
      expect(user).not_to be_valid
    end

    it 'is not valid when updating with invalid attributes' do
      user = create(:user)
      user.phone_number = '+912319477349'
      expect(user).not_to be_valid
    end
  end
end
