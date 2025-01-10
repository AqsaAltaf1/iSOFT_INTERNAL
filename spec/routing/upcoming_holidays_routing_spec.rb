# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpcomingHolidaysController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/upcoming_holidays').to route_to('upcoming_holidays#index')
    end

    it 'routes to #new' do
      expect(get: '/upcoming_holidays/new').to route_to('upcoming_holidays#new')
    end

    it 'routes to #show' do
      expect(get: '/upcoming_holidays/1').to route_to('upcoming_holidays#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/upcoming_holidays/1/edit').to route_to('upcoming_holidays#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/upcoming_holidays').to route_to('upcoming_holidays#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/upcoming_holidays/1').to route_to('upcoming_holidays#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/upcoming_holidays/1').to route_to('upcoming_holidays#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/upcoming_holidays/1').to route_to('upcoming_holidays#destroy', id: '1')
    end
  end
end
