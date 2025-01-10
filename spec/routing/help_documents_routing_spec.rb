# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HelpDocumentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/help_documents').to route_to('help_documents#index')
    end

    it 'routes to #new' do
      expect(get: '/help_documents/new').to route_to('help_documents#new')
    end

    it 'routes to #show' do
      expect(get: '/help_documents/1').to route_to('help_documents#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/help_documents/1/edit').to route_to('help_documents#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/help_documents').to route_to('help_documents#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/help_documents/1').to route_to('help_documents#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/help_documents/1').to route_to('help_documents#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/help_documents/1').to route_to('help_documents#destroy', id: '1')
    end
  end
end
