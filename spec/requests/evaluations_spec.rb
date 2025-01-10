# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Evaluations', type: :request do
  before(:each) do
    @company = create(:company, status: 'active')
    @permission1 = create(:permission, name: 'create_evaluation', controller: 'Evaluation', controller_method: 'create')
    @permission2 = create(:permission, name: 'edit_evaluation', controller: 'Evaluation', controller_method: 'create')
    @role = create(:role, name: 'admin', permission_ids_input: [@permission1.id, @permission2.id])
    @current_user = create(:user, user_type: 'admin', status: 'active', company_id: @company.id,
                                  role_id: @role.id)
    @user = create(:user, user_type: 'user', status: 'active', company_id: @company.id)
    sign_in(@current_user)
  end

  let(:valid_attributes) do
    {
      name: Faker::Name.name, file: Rack::Test::UploadedFile.new('spec/fixtures/ISOFTSTUDIOS.png'),
      company_id: @current_user.company_id
    }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      evaluation = create(:evaluation, company_id: @company.id, created_by: @current_user.id)
      get evaluations_url
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get new_evaluation_url
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    it 'creates a new evaluation with associated questions' do
      user_ids = [@user.id]
      evaluation_params = attributes_for(:evaluation, company_id: @company.id)
                          .merge(questions_attributes: [attributes_for(:question,
                                                                       company_id: @company.id)], user_ids:)
      expect do
        post evaluations_url, params: { evaluation: evaluation_params }
      end.to change(Evaluation, :count).by(1)
      created_evaluation = Evaluation.last
      expect(created_evaluation.questions.count).to eq(1)
      expect(created_evaluation.user_ids).to match_array(user_ids)
    end

    it 'redirects to all evaluations' do
      user_ids = [@user.id]
      evaluation_params = attributes_for(:evaluation, company_id: @company.id)
                          .merge(questions_attributes: [attributes_for(:question,
                                                                       company_id: @company.id)], user_ids:)
      expect do
        post evaluations_url, params: { evaluation: evaluation_params }
      end.to change(Evaluation, :count).by(1)
      created_evaluation = Evaluation.last
      expect(created_evaluation.questions.count).to eq(1)
      expect(created_evaluation.user_ids).to match_array(user_ids)
      expect(response).to redirect_to(evaluations_url)
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      evaluation = create(:evaluation, company_id: @company.id, created_by: @current_user.id)
      get evaluation_path(evaluation)
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      user_ids = [@user.id]
      evaluation_params = attributes_for(:evaluation, company_id: @company.id)
                          .merge(questions_attributes: [attributes_for(:question,
                                                                       company_id: @company.id)], user_ids:)
      expect do
        post evaluations_url, params: { evaluation: evaluation_params }
      end.to change(Evaluation, :count).by(1)
      created_evaluation = Evaluation.last
      expect(created_evaluation.questions.count).to eq(1)
      expect(created_evaluation.user_ids).to match_array(user_ids)
      get edit_evaluation_url(created_evaluation)
      expect(response).to be_successful
    end

    it 'will not allow to edit except pending evaluation' do
      user_ids = [@user.id]
      evaluation_params = attributes_for(:evaluation, company_id: @company.id, status: 'approved')
                          .merge(questions_attributes: [attributes_for(:question,
                                                                       company_id: @company.id)], user_ids:)
      expect do
        post evaluations_url, params: { evaluation: evaluation_params }
      end.to change(Evaluation, :count).by(1)
      created_evaluation = Evaluation.last
      expect(created_evaluation.questions.count).to eq(1)
      expect(created_evaluation.user_ids).to match_array(user_ids)
      get edit_evaluation_url(created_evaluation)
      expect(response).to redirect_to(evaluations_url)
      expect(flash[:alert]).to include('You Can Not Edit Evaluation with Approved , Active or Rejected Status.')
    end
  end

  describe 'PATCH #update' do
    it 'updates an existing evaluation' do
      user_ids = [@user.id]
      evaluation_params = attributes_for(:evaluation, company_id: @company.id)
                          .merge(questions_attributes: [attributes_for(:question,
                                                                       company_id: @company.id)], user_ids:)
      post evaluations_url, params: { evaluation: evaluation_params }
      expect do
        post evaluations_url, params: { evaluation: evaluation_params }
      end.to change(Evaluation, :count).by(1)

      created_evaluation = Evaluation.last
      expect(created_evaluation.questions.count).to eq(1)
      expect(created_evaluation.user_ids).to match_array(user_ids)
      patch evaluation_path(created_evaluation), params: { evaluation: { title: Faker::Name.name } }
      created_evaluation.reload

      expect(response).to be_redirect
      expect(flash[:notice]).to eq('Evaluation is successfully updated.')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes an evaluation' do
      evaluation = create(:evaluation, company_id: @company.id, created_by: @current_user.id)
      expect do
        delete evaluation_path(evaluation)
      end.to change(Evaluation, :count).by(-1)
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to the evaluations list' do
      evaluation = create(:evaluation, company_id: @company.id, created_by: @current_user.id)
      delete evaluation_path(evaluation)
      expect(response).to redirect_to(evaluations_url)
    end
  end
end
