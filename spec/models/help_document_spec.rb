# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HelpDocument, type: :model do
  context 'validation tests' do
    it 'should validates presence of name' do
      help_document = build(:help_document, name: nil).save
      expect(help_document).to eq(false)
    end

    it 'should not save help document for invalid type of file' do
      help_document = build(:help_document, file: Rack::Test::UploadedFile.new('spec/fixtures/no-image.zip')).save
      expect(help_document).to eq(false)
    end

    it 'should save help document successfully' do
      help_document = create(:help_document)
      expect(help_document).to be_valid
    end
  end
end
