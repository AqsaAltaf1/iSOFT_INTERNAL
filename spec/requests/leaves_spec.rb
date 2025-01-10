# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Leaves', type: :request do
  before(:each) do
    @company = create(:company)
    @current_user = create(:user, company_id: @company.id)
    sign_in(@current_user)
  end

  let(:valid_attributes) do
    apply_leave = create(:apply_leave, company_id: @current_user.company_id)
    {
      apply_leave_id: apply_leave.id, date_from: Date.today, date_to: Date.today + rand(1..10),
      company_id: @current_user.company_id, user_id: @current_user.id
    }
  end

  let(:invalid_attributes) do
    { apply_leave_id: nil, date_from: nil, date_to: nil, user_id: nil }
  end

  let(:invalid_dates_attributes) do
    apply_leave = create(:apply_leave, company_id: @company.id)
    @user = create(:user, company_id: @company.id)
    { apply_leave_id: apply_leave.id, date_from: Date.today, date_to: Date.today + 300, user_id: nil }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Leave.create! valid_attributes
      get leaves_url
      expect(response).to be_successful
    end
    it 'check approval or rejection' do
      leave = Leave.create! valid_attributes
      get leaves_url, params: { leave: leave.id }
      expect(response).to be_successful
    end
    it 'tests ajax request when user_id is present' do
      leave = Leave.create! valid_attributes
      get leaves_url, xhr: true, params: { user_id: leave.user.id }
      expect(response).to be_successful
    end
  end
  describe 'GET /new' do
    it 'renders a successful response' do
      get new_leave_url
      expect(response).to be_successful
    end
    it 'cannot apply when already have pending leave request' do
      leave = Leave.create! valid_attributes
      get new_leave_url
      expect(response).to redirect_to(leaves_url(status: 'pending'))
      expect(flash[:alert]).to include('You already have penidng leave request')
    end
  end
  describe 'GET /show' do
    it 'renders a successful response for leave owner' do
      leave = Leave.create! valid_attributes
      get leave_url(leave)
      expect(response).to be_successful
    end
    it 'renders a successful response for admin' do
      @admin = create(:user, company_id: @company.id, role: 'admin')
      sign_in(@admin)
      leave = Leave.create! valid_attributes
      get leave_url(leave)
      expect(response).to be_successful
    end
    it 'renders a successful response for employee' do
      @employee = create(:user, company_id: @company.id, role: 'employee')
      sign_in(@employee)
      leave = Leave.create! valid_attributes
      get leave_url(leave)
      expect(response).to redirect_to(leaves_url)
      expect(flash[:alert]).to include('You are not authorize for this.')
    end
  end
  describe 'POST /create' do
    context 'with valid parameters' do
      it 'cannot apply for previous days' do
        @user_leave = create(:leave, user_id: @current_user.id, date_from: Date.today, company_id: @company.id)
        @user_leave.update(status: 'approved')
        post leaves_url params: { leave: valid_attributes }
        expect(response.status).to eq(422)
      end
      it 'cannot apply for more than allowed days' do
        post leaves_url params: { leave: invalid_dates_attributes }
        expect(response.status).to eq(422)
      end

      it 'creates a new Leave' do
        expect do
          post leaves_url, params: { leave: valid_attributes }
        end.to change(Leave, :count).by(1)
      end

      it 'redirects to the leaves' do
        post leaves_url, params: { leave: valid_attributes }
        expect(response).to redirect_to(leaves_url)
        expect(flash[:notice]).to include('Leave was successfully created.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Leave' do
        expect do
          post leaves_url, params: { leave: invalid_attributes }
        end.to change(Leave, :count).by(0)
      end
      it 'should accept turbo form' do
        post leaves_url params: { leave: invalid_attributes, format: :turbo_stream }
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
      end
      it 'should render turbo form' do
        post leaves_url params: { leave: invalid_attributes, format: :turbo_stream }
        expect(response).to render_template('leaves/_form')
      end
    end
  end
end
