# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'is valid with valid attributes' do
    question = create(:question)
    expect(question).to be_valid
  end

  it 'is not valid without a question' do
    question = build(:question, question: nil).save
    expect(question).to eq(false)
  end
end
