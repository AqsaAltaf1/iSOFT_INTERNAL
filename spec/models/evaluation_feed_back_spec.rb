# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationFeedBack, type: :model do
  before(:all) do
    @feedback1 = FactoryBot.create(:evaluation_feed_back)
  end

  it 'is valid with valid attributes' do
    expect(@feedback1).to be_valid
  end
end
