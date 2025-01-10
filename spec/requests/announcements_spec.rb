# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Announcements', type: :request do
  before(:each) do
    @current_user = create(:user)
    sign_in(@current_user)
  end

  let(:valid_attributes) do
    {
      title: Faker::Name.name,
      body: Faker::Company.catch_phrase,
      company_id: @current_user.company_id
    }
  end

  let(:invalid_attributes) do
    { title: nil, body: nil }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Announcement.create! valid_attributes
      get announcements_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      announcement = Announcement.create! valid_attributes
      get announcement_url(announcement)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_announcement_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      announcement = Announcement.create! valid_attributes
      get edit_announcement_url(announcement)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Announcement' do
        expect do
          post announcements_url, params: { announcement: valid_attributes }
        end.to change(Announcement, :count).by(1)
        expect(flash[:notice]).to eq('Announcement was successfully created.')
      end

      it 'send email when new Announcement is created' do
        expect do
          post announcements_url, params: { announcement: valid_attributes }
        end.to have_enqueued_job(ActionMailer::MailDeliveryJob).at_least(1).times
      end

      it 'redirects to the created announcement' do
        post announcements_url, params: { announcement: valid_attributes }
        expect(response).to redirect_to(announcement_url(Announcement.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Announcement' do
        expect do
          post announcements_url, params: { announcement: invalid_attributes }
        end.to change(Announcement, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post announcements_url, params: { announcement: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          title: Faker::Name.name,
          body: Faker::Company.catch_phrase,
          company_id: @current_user.company_id
        }
      end

      it 'updates the requested announcement' do
        announcement = Announcement.create! valid_attributes
        patch announcement_url(announcement), params: { announcement: new_attributes }
        announcement.reload
        expect(announcement).to be_valid
        expect(flash[:notice]).to eq('Announcement was successfully updated.')
      end

      it 'redirects to the announcement' do
        announcement = Announcement.create! valid_attributes
        patch announcement_url(announcement), params: { announcement: new_attributes }
        announcement.reload
        expect(response).to redirect_to(announcement_url(announcement))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        announcement = Announcement.create! valid_attributes
        patch announcement_url(announcement), params: { announcement: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested announcement' do
      announcement = Announcement.create! valid_attributes
      expect do
        delete announcement_url(announcement)
      end.to change(Announcement, :count).by(-1)
      expect(flash[:notice]).to eq('Announcement was successfully destroyed.')
    end

    it 'redirects to the announcements list' do
      announcement = Announcement.create! valid_attributes
      delete announcement_url(announcement)
      expect(response).to redirect_to(announcements_url)
    end
  end
end
