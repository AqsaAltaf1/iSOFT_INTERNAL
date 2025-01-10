
class Api::V1::AttendancesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_before_action :verify_authenticity_token
  before_action :decode_token
  def index
    request_body = JSON.parse(request.body.read)
    puts request_body
    CreateAttendanceJob.perform_now(request_body, @current_company) 
    render json: { data: "connected successfully", status: "success"}
  end
  def decode_token
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      secret_key = ENV['JWT_SECRET_KEY']
      decoded_token, _ = JWT.decode(header, secret_key, true, algorithm: 'HS256')
      HashWithIndifferentAccess.new decoded_token
      @current_company = Company.find(decoded_token.values[0])
    rescue JWT::ExpiredSignature
      render json: { valid: false, error: 'Expired token' }, status: :unprocessable_entity
    rescue JWT::DecodeError
      render json: { valid: false, error: 'Invalid token' }, status: :unprocessable_entity
    end
  end
end
