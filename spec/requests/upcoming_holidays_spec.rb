# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/upcoming_holidays', type: :request do
  before(:each) do
    @current_user = create(:user)
    sign_in(@current_user)
  end

  let(:valid_attributes) do
    {
      title: Faker::Name.name, description: Faker::Company.catch_phrase,
      date: Faker::Date.forward(days: 2),
      company_id: @current_user.company_id
    }
  end

  let(:invalid_attributes) do
    { title: nil, description: nil, date: nil }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      UpcomingHoliday.create! valid_attributes
      get upcoming_holidays_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      upcoming_holiday = UpcomingHoliday.create! valid_attributes
      get upcoming_holiday_url(upcoming_holiday)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_upcoming_holiday_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      upcoming_holiday = UpcomingHoliday.create! valid_attributes
      get edit_upcoming_holiday_url(upcoming_holiday)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new UpcomingHoliday' do
        expect do
          post upcoming_holidays_url, params: { upcoming_holiday: valid_attributes }
        end.to change(UpcomingHoliday, :count).by(1)
      end

      it 'redirects to all upcoming_holidays' do
        post upcoming_holidays_url, params: { upcoming_holiday: valid_attributes }
        expect(response).to redirect_to(upcoming_holidays_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new UpcomingHoliday' do
        expect do
          post upcoming_holidays_url, params: { upcoming_holiday: invalid_attributes }
        end.to change(UpcomingHoliday, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post upcoming_holidays_url, params: { upcoming_holiday: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          title: Faker::Name.name, description: Faker::Company.catch_phrase,
          date: Faker::Date.forward(days: 2),
          company_id: @current_user.company_id
        }
      end

      it 'updates the requested upcoming_holiday' do
        upcoming_holiday = UpcomingHoliday.create! valid_attributes
        patch upcoming_holiday_url(upcoming_holiday), params: { upcoming_holiday: new_attributes }
        upcoming_holiday.reload
        expect(response).to be_redirect
        expect(flash[:notice]).to eq('holiday was successfully updated.')
      end

      it 'redirects to the upcoming_holiday' do
        upcoming_holiday = UpcomingHoliday.create! valid_attributes
        patch upcoming_holiday_url(upcoming_holiday), params: { upcoming_holiday: new_attributes }
        upcoming_holiday.reload
        expect(response).to redirect_to(upcoming_holiday_url(upcoming_holiday))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        upcoming_holiday = UpcomingHoliday.create! valid_attributes
        patch upcoming_holiday_url(upcoming_holiday), params: { upcoming_holiday: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested upcoming_holiday' do
      upcoming_holiday = UpcomingHoliday.create! valid_attributes
      expect do
        delete upcoming_holiday_url(upcoming_holiday)
      end.to change(UpcomingHoliday, :count).by(-1)
    end

    it 'redirects to the upcoming_holidays list' do
      upcoming_holiday = UpcomingHoliday.create! valid_attributes
      delete upcoming_holiday_url(upcoming_holiday)
      expect(response).to redirect_to(upcoming_holidays_url)
    end
  end
end
