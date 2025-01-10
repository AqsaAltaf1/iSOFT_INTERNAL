# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  before(:each) do
    @company = create(:company, status: 'active')
    @current_user = create(:user, company_id: @company.id, user_type: 'admin', status: 'active')
    sign_in(@current_user)
  end
  let(:valid_attributes) do
    { name: Faker::Name.name, description: Faker::Company.catch_phrase, user_ids: [@current_user.id],
      company_id: @company.id }
  end
  let(:invalid_attributes) do
    { name: nil, description: nil, user_ids: nil }
  end
  describe 'GET /index' do
    it 'renders a successful response' do
      project = FactoryBot.create(:project, company: @company)
      get projects_url
      expect(response).to be_successful
    end
  end
  describe 'GET /show' do
    it 'renders a successful response' do
      project = FactoryBot.create(:project, company: @company)
      get project_url(project)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_project_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      project = FactoryBot.create(:project, company: @company)
      get edit_project_url(project)
      expect(response).to be_successful
    end
  end
  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Project' do
        expect do
          post projects_url, params: { project: valid_attributes }
        end.to change(Project, :count).by(1)
      end

      it 'redirects to the created project' do
        post projects_url, params: { project: valid_attributes }
        expect(response).to redirect_to(projects_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Project' do
        expect do
          post projects_url, params: { project: invalid_attributes }
        end.to change(Project, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post projects_url, params: { project: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: Faker::Name.name }
      end

      it 'updates the requested project' do
        project = FactoryBot.create(:project, company: @company)
        patch project_url(project), params: { project: new_attributes }
        project.reload
        expect(response).to be_redirect
        expect(flash[:notice]).to eq('Project updated successfully.')
      end

      it 'redirects to the projects' do
        project = FactoryBot.create(:project, company: @company)
        patch project_url(project), params: { project: new_attributes }
        project.reload
        expect(response).to redirect_to(projects_url)
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        project = FactoryBot.create(:project, company: @company)
        patch project_url(project), params: { project: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested project' do
      project = FactoryBot.create(:project, company: @company)
      expect do
        delete project_url(project)
      end.to change(Project, :count).by(-1)
    end

    it 'redirects to the projects list' do
      project = FactoryBot.create(:project, company: @company)
      delete project_url(project)
      expect(response).to redirect_to(projects_url)
    end
  end
end
