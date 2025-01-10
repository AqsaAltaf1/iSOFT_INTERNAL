# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Companies', type: :request do
  before(:each) do
    @current_user = create(:user, user_type: 'admin', status: 'active')
    sign_in(@current_user)
  end

  let(:valid_attributes) do
    { name: Faker::Company.name, subdomain: Faker::Internet.domain_word + rand(100..999).to_s,
      status: Company.statuses.keys.sample }
  end
  let(:invalid_attributes) do
    { name: nil, subdomain: nil }
  end

  describe 'GET /companies' do
    it 'renders the index template' do
      get companies_path
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_company_url
      expect(response).to be_successful
    end
  end

  describe 'POST /companies' do
    context 'with valid parameters' do
      it 'creates a new company' do
        company_params = { company: valid_attributes }
        expect { post companies_path, params: company_params }.to change(Company, :count).by(1)
        expect(response).to redirect_to(companies_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new company' do
        invalid_company_params = { company: invalid_attributes }
        expect { post companies_path, params: invalid_company_params }.not_to change(Company, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET companies' do
    let(:company) { create(:company) }
    it 'renders the edit template' do
      get edit_company_path(company)
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH companies' do
    let(:new_valid_attributes) do
      { name: Faker::Company.name, subdomain: Faker::Internet.domain_word + rand(100..999).to_s,
        status: Company.statuses.keys.sample }
    end
    let(:new_invalid_attributes) do
      { name: nil, subdomain: nil }
    end
    let(:company) { create(:company) }
    context 'with valid parameters' do
      it 'updates the company' do
        patch company_path(company), params: { company: new_valid_attributes }
        expect(response).to redirect_to(companies_path)
        expect(flash[:notice]).to eq('Company is successfully updated.')
        company.reload
        expect(company.name).to eq(company.name)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the company' do
        patch company_path(company), params: { company: new_invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
        company.reload
        expect(company.name).not_to eq(false)
      end
    end
  end

  describe 'DELETE companies' do
    let!(:company) { create(:company) }
    it 'destroys the company' do
      expect do
        delete company_path(company)
      end.to change(Company, :count).by(-1)
      expect(response).to redirect_to(companies_path)
      expect(flash[:notice]).to eq('Company is successfully destroyed.')
    end
  end
end
