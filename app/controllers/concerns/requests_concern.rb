# frozen_string_literal: true

module RequestsConcern
  extend ActiveSupport::Concern
  included do
    before_action :get_status, only: %i[new]
    before_action :authenticate_user!
  end
  def create_request
    previous_requests = 0
    @user_applied_request = current_user.requests.selected_requests('approved')
    @user_applied_request.each do |previous_dates|
      if  previous_dates.request_type == "expense" && (previous_dates[:details]["date_to"] == request_params[:details]["date_from"] || previous_dates[:details]["date_to"] == request_params[:details]["date_to"] || previous_dates[:details]["date_from"] == request_params[:details]["date_to"] || previous_dates[:details]["date_from"] == request_params[:details]["date_from"])
        previous_requests = 1
      end
    end
    if previous_requests == 1
      respond_to do |format|
        @request.errors.add(:base, 'Sorry, you you have already applied for these days')
        format.html { render :new, flash: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    else
      respond_to do |format|
        if @request.save
          request_notify_recipient(@request, current_user, RequestNotification)
          format.html { redirect_to request_url(@request), notice: "Request is successfully created." }
          format.json { render :show, status: :created, location: @request }
        else
          set_partial(format)
        end
      end
    end
  end

  def upload_image(image_data)
    cloudinary_upload = Cloudinary::Uploader.upload(image_data['attachment'])
    @request.details['attachment_url'] = cloudinary_upload['url']
    @request.details['key'] = cloudinary_upload['api_key']
  end

  def get_status
    @request_type = params[:request_type]
    if current_user.requests.exists? && current_user.requests.where(status: 'pending', request_type: @request_type ).exists?
      respond_to do |format|
        format.html { redirect_to requests_url, alert: 'You already have pending request' }
      end
    else
      @request = Request.new
    end
  end
   
  def edit_request
    parse_expense_dates if @request.request_type == "expense"
    parse_loan_dates if @request.request_type == "loan"
    @request_type = @request.request_type
  end

  def set_partial(format)
    parse_expense_dates if @request.request_type == "expense"
    parse_loan_dates if @request.request_type == "loan"
    @request_type = @request.request_type
    if @request.request_type == "loan"
      format.turbo_stream { render turbo_stream: turbo_stream.update('remote_modal_body', partial: 'loan_request', locals: { request: @request }) }
    elsif @request.request_type == "expense"
      format.turbo_stream { render turbo_stream: turbo_stream.update('remote_modal_body', partial: 'expense_request', locals: { request: @request }) }
    elsif @request.request_type == "document"
      format.turbo_stream { render turbo_stream: turbo_stream.update('remote_modal_body', partial: 'document_request', locals: { request: @request }) }
    end
  end

  def render_format
    if params[:request_status]
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end

  private

  def parse_expense_dates
    @request.details["date_from"] = Date.parse(@request.details["date_from"])
    @request.details["date_to"] = Date.parse(@request.details["date_to"])
  end

  def parse_loan_dates
    @request.details["payment_start_date"] = Date.parse(@request.details["payment_start_date"]) if @request.details["payment_start_date"].present?
    @request.details["taken_date"] = Date.parse(@request.details["taken_date"]) if @request.details["taken_date"].present?
  end

end
