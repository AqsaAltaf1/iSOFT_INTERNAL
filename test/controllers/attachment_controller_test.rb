# frozen_string_literal: true

require 'test_helper'

class AttachmentControllerTest < ActionDispatch::IntegrationTest
  test 'should get create' do
    get attachment_create_url
    assert_response :success
  end

  test 'should get new' do
    get attachment_new_url
    assert_response :success
  end
end
