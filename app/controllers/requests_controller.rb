class RequestsController < ApplicationController
  before_action :authenticate_user!
  include RequestsConcern
  before_action :set_request, only: %i[ show edit update destroy ]
  # before_action :verify_authorized, only: %i[create index]

  def index
    status = params[:request_status].present? ? params[:request_status].downcase : 'pending'
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      params[:status].present? ? @requests = @user.requests.selected_requests(params[:status]) : @requests = @user.requests
    else
      @requests = current_user.requests.selected_requests(status)
    end
    @types_requests = @requests.group(:request_type).count
    render_format
  end

  def show
    # authorize @request
    if params[:request_status]
      @request = Request.find(params[:request])
      @request.update(status: params[:request_status])
      request_notify_recipient(@request, @request.user, RequestApprovalNotification)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('request_details',
                                                    partial: 'requests/request',
                                                    locals: { request: @request })
        end
      end
    end
    @request_notes = @request.notes.order(created_at: :asc)
    mark_request_notifications_as_read
  end

  def new
    @request_type = params[:request_type]
    @request = Request.new
  end

  def edit
    edit_request
  end

  def create
    @request = current_user.requests.build(request_params)
    upload_image(params['request']['details']) if @request.request_type == 'expense' && params['request']['details']['attachment'].present?
    create_request 
  end

  def update
    # authorize @request
    upload_image(params['request']['details']) if @request.request_type == 'expense' && params['request']['details']['attachment'].present?
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to request_path(@request), notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        set_partial(format)
      end
    end
  end

  def destroy
    authorize @request
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: "Request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_request
    @request = Request.find(params[:id])
  end

  def verify_authorized
    authorize Request
  end

  def request_params
    params.require(:request).permit(:request_type, :user_id, :company_id, :status, details:{})
  end
end
