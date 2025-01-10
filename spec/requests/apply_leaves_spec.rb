# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/apply_leaves', type: :request do
  before(:each) do
    @current_user = create(:user)
    sign_in(@current_user)
  end

  let(:valid_attributes) do
    { allowed_leave_type: Faker::Name.name, allowed_day: Faker::Number.within(range: 10..15),
      company_id: @current_user.company_id }
  end

  let(:invalid_attributes) do
    { allowed_leave_type: nil, allowed_day: nil }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      ApplyLeave.create! valid_attributes
      get apply_leaves_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      apply_leave = ApplyLeave.create! valid_attributes
      get apply_leave_url(apply_leave)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_apply_leave_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      apply_leave = ApplyLeave.create! valid_attributes
      get edit_apply_leave_url(apply_leave)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new ApplyLeave' do
        expect do
          post apply_leaves_url, params: { apply_leave: valid_attributes }
        end.to change(ApplyLeave, :count).by(1)
        expect(flash[:notice]).to eq('Apply leave was successfully created.')
      end

      it 'redirects to the created apply_leave' do
        post apply_leaves_url, params: { apply_leave: valid_attributes }
        expect(response).to redirect_to(apply_leave_url(ApplyLeave.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new ApplyLeave' do
        expect do
          post apply_leaves_url, params: { apply_leave: invalid_attributes }
        end.to change(ApplyLeave, :count).by(0)
      end
      it "renders a successful response (i.e. to display the 'new' template)" do
        post apply_leaves_url, params: { apply_leave: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { allowed_leave_type: Faker::Name.name, allowed_day: Faker::Number.within(range: 10..15),
          company_id: @current_user.company_id }
      end

      it 'updates the requested apply_leave' do
        apply_leave = ApplyLeave.create! valid_attributes
        patch apply_leave_url(apply_leave), params: { apply_leave: new_attributes }
        apply_leave.reload
        expect(response).to be_redirect
        expect(flash[:notice]).to eq('Apply leave was successfully updated.')
      end

      it 'redirects to the apply_leave' do
        apply_leave = ApplyLeave.create! valid_attributes
        patch apply_leave_url(apply_leave), params: { apply_leave: new_attributes }
        apply_leave.reload
        expect(response).to redirect_to(apply_leave_url(apply_leave))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        apply_leave = ApplyLeave.create! valid_attributes
        patch apply_leave_url(apply_leave), params: { apply_leave: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested apply_leave' do
      apply_leave = ApplyLeave.create! valid_attributes
      expect do
        delete apply_leave_url(apply_leave)
      end.to change(ApplyLeave, :count).by(-1)
      expect(flash[:notice]).to eq('Apply leave was successfully destroyed.')
    end

    it 'redirects to the apply_leaves list' do
      apply_leave = ApplyLeave.create! valid_attributes
      delete apply_leave_url(apply_leave)
      expect(response).to redirect_to(apply_leaves_url)
    end
  end
end
