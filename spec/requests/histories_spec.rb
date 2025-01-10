# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  before(:each) do
    @company = create(:company, status: 'active')
    @current_user = create(:user, company_id: @company.id, user_type: 'admin', status: 'active')
    @company_asset = create(:company_asset, company_id: @company.id)
    sign_in(@current_user)
  end

  let(:valid_attributes) do
    {
      given_date: Date.today,
      return_date: Date.today + 1,
      assigned_by: Faker::Name.name,
      user_id: @current_user.id,
      company_id: @company.id,
      company_asset_id: @company_asset.id
    }
  end

  let(:invalid_attributes) do
    {
      given_date: nil,
      return_date: nil,
      assigned_by: nil,
      user_id: @current_user.id,
      company_id: @company.id,
      company_asset_id: @company_asset.id
    }
  end

  describe 'GET #new' do
    it 'assigns a new history as @history' do
      get new_history_path, params: { company_asset_id: @company_asset.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new History' do
        expect do
          post histories_url params: { history: valid_attributes }
        end.to change(History, :count).by(1)
      end

      it 'redirects to the created history' do
        post histories_url, params: { history: valid_attributes }
        expect(response).to redirect_to(company_asset_url(assigns(:history).company_asset))
      end
    end

    context 'with invalid params' do
      it 'renders the new template' do
        post histories_url, params: { history: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested history as @history' do
      history = create(:history, company_id: @company.id, user_id: @current_user.id,
                                 company_asset_id: @company_asset.id)
      get edit_history_url(history)
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'assigns the requested history as @history' do
      history = create(:history, company_id: @company.id, user_id: @current_user.id,
                                 company_asset_id: @company_asset.id)
      get history_url(history)
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          given_date: Date.today,
          return_date: Date.today + 1,
          assigned_by: Faker::Name.name,
          user_id: @current_user.id,
          company_id: @company.id,
          company_asset_id: @company_asset.id
        }
      end

      it 'updates the requested history' do
        history = create(:history, company_id: @company.id, user_id: @current_user.id,
                                   company_asset_id: @company_asset.id)
        patch history_url(history), params: { history: new_attributes }
        history.reload
        expect(response).to be_redirect
        expect(flash[:notice]).to eq('History was successfully updated.')
      end

      it 'redirects to the history' do
        history = create(:history, company_id: @company.id, user_id: @current_user.id,
                                   company_asset_id: @company_asset.id)
        patch history_url(history), params: { history: new_attributes }
        history.reload
        expect(response).to redirect_to(company_asset_url(history.company_asset))
      end
    end

    context 'with invalid params' do
      it 'renders the edit template' do
        history = create(:history, company_id: @company.id, user_id: @current_user.id,
                                   company_asset_id: @company_asset.id)
        patch history_url(history), params: { history: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end
end
