# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TimeSheets', type: :request do
  before(:each) do
    @company = create(:company, status: 'active')
    @permission1 = create(:permission, name: 'create_time_sheet', controller: 'TimeSheet', controller_method: 'create')
    @permission2 = create(:permission, name: 'update_time_sheet', controller: 'TimeSheet', controller_method: 'create')
    @role = create(:role, name: 'admin', permission_ids_input: [@permission1.id, @permission2.id])
    @current_user = create(:user, user_type: 'admin', status: 'active', company_id: @company.id,
                                  role_id: @role.id)
    sign_in(@current_user)
    @project = create(:project, company_id: @company.id)
  end

  let(:valid_attributes) do
    {
      description: Faker::Lorem.paragraph(sentence_count: 5),
      date: Date.today,
      time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
      project_id: @project.id,
      company_id: @company.id,
      user_id: @current_user.id
    }
  end

  describe 'GET #index' do
    it 'renders the index template' do
      TimeSheet.create! valid_attributes
      get time_sheets_path
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      time_sheet = TimeSheet.create! valid_attributes
      get time_sheet_path(time_sheet)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_time_sheet_path
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'creates a new time sheet' do
      expect do
        post time_sheets_url, params: { time_sheet: valid_attributes }
      end.to change(TimeSheet, :count).by(1)
      created_time_sheet = TimeSheet.last
      expected_url = "http://www.example.com/time_sheets?data=#{created_time_sheet.date.strftime('%A')}&id=#{created_time_sheet.id}"
      expect(response).to redirect_to(expected_url)
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      time_sheet = TimeSheet.create! valid_attributes
      get edit_time_sheet_url(time_sheet)
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    it 'updates the time sheet' do
      time_sheet = TimeSheet.create! valid_attributes
      patch time_sheet_path(time_sheet),
            params: { time_sheet: { description: Faker::Lorem.paragraph(sentence_count: 5) } }
      time_sheet.reload
      expect(response).to be_redirect
      expect(flash[:notice]).to eq('Time sheet updated successfully.')
      expected_url = "http://www.example.com/time_sheets?data=#{time_sheet.date.strftime('%A')}&n_time_sheet=#{time_sheet.id}"
      expect(response).to redirect_to(expected_url)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the time sheet' do
      time_sheet = TimeSheet.create! valid_attributes
      expect do
        delete time_sheet_path(time_sheet)
      end.to change(TimeSheet, :count).by(-1)
      expect(response).to redirect_to(time_sheets_path)
      expect(flash[:notice]).to eq('Time sheet deleted successfully')
    end
  end
end
