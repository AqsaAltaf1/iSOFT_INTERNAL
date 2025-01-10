# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyAssetsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/company_assets').to route_to('company_assets#index')
    end

    it 'routes to #new' do
      expect(get: '/company_assets/new').to route_to('company_assets#new')
    end

    it 'routes to #show' do
      expect(get: '/company_assets/1').to route_to('company_assets#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/company_assets/1/edit').to route_to('company_assets#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/company_assets').to route_to('company_assets#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/company_assets/1').to route_to('company_assets#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/company_assets/1').to route_to('company_assets#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/company_assets/1').to route_to('company_assets#destroy', id: '1')
    end
  end
end
