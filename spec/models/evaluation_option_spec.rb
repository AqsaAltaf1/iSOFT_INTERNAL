# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationOption, type: :model do
  before(:all) do
    @option1 = FactoryBot.create(:evaluation_option)
  end

  it 'is valid with valid attributes' do
    expect(@option1).to be_valid
  end

  # it "is valid" do
  #   @option2 = FactoryBot.create(:evaluation_option, option: 'Option 2 of testing evaluation')
  #   expect(@option2).to be_valid
  # end
end
