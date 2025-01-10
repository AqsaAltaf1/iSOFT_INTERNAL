# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  before(:each) do
    @role = create(:role)
    @current_user = create(:user, status: 'active')
    sign_in(@current_user)
  end

  let(:valid_attributes) do
    {
      first_name: Faker::Name.name, last_name: Faker::Name.name, email: Faker::Internet.email,
      phone_number: "+923#{Faker::PhoneNumber.subscriber_number(length: 9)}", user_type: User.user_types.keys.sample,
      role_id: @role.id, joining_date: Date.today, password: Faker::Internet.password, status: 'active',
      company_id: @current_user.company_id, avatar: Rack::Test::UploadedFile.new('spec/fixtures/ISOFTSTUDIOS.png')
    }
  end

  let(:invalid_attributes) do
    {
      first_name: nil, last_name: nil, phone_number: nil, joining_date: Date.today, password: nil,
      avatar: Rack::Test::UploadedFile.new('spec/fixtures/no-image.zip')
    }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      User.create! valid_attributes
      get home_employee_details_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      user = User.create! valid_attributes
      get user_url(user)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_user_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      user = User.create! valid_attributes
      get edit_user_url(user)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect do
          post users_url, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        expect do
          post users_url, params: { user: invalid_attributes }
        end.to change(User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post users_url, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { first_name: Faker::Name.name, last_name: Faker::Name.name, email: @current_user.email,
          phone_number: "+923#{Faker::PhoneNumber.subscriber_number(length: 9)}", role_id: @current_user.role, joining_date: Date.today, password: Faker::Internet.password, company_id: @current_user.company_id, avatar: Rack::Test::UploadedFile.new('spec/fixtures/ISOFTSTUDIOS.png') }
      end

      it 'updates the requested user' do
        patch user_url(@current_user), params: { user: new_attributes }
        @current_user.reload
        expect(response).to be_redirect
        expect(flash[:notice]).to eq('Account has been updated successfully .')
      end

      it 'redirects to the user' do
        patch user_url(@current_user), params: { user: new_attributes }
        @current_user.reload
        expect(response).to redirect_to(home_employee_details_url)
      end
    end

    context 'with invalid parameters' do
      let(:new_invalid_attributes) do
        {
          first_name: nil, last_name: nil, email: @current_user.email,
          phone_number: "+922#{Faker::PhoneNumber.subscriber_number(length: 11)}",
          password: Faker::Internet.password, company_id: @current_user.company_id,
          avatar: Rack::Test::UploadedFile.new('spec/fixtures/ISOFTSTUDIOS.png')
        }
      end

      it "renders an unsuccessful response (i.e., to display the 'form_update' template)" do
        patch user_url(@current_user), params: { user: new_invalid_attributes, format: :turbo_stream }
        expect(response).to render_template(:form_update)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect do
        delete user_url(user)
      end.to change(User, :count).by(-1)
    end

    it 'sets a success notice' do
      user = User.create! valid_attributes
      delete user_url(user)
      expect(flash[:notice]).to eq('user is successfully destroyed.')
    end

    it 'redirect to home_emplyee_details_path' do
      user = User.create! valid_attributes
      delete user_url(user)
      expect(response).to redirect_to(home_employee_details_path)
    end
  end
end
