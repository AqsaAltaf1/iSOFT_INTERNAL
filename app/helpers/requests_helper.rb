module RequestsHelper
  def render_request_partial(request_type, request)
    if request_type == "expense"
      render 'expense_request', request: request
    elsif request_type == "loan"
      render 'loan_request', request: request
    elsif request_type == "document"
      render 'document_request', request: request
    end
  end

  def pending
    if params[:request_status].present?
      params[:request_status].downcase == 'pending' ? 'text-danger' : ''
    else
      'text-danger'
    end
  end

  def approved
    if params[:request_status].present?
      params[:request_status].downcase == 'approved' ? 'text-danger' : ''
    else
      ''
    end
  end

  def rejected
    if params[:request_status].present?
      params[:request_status].downcase == 'rejected' ? 'text-danger' : ''
    else
      ''
    end
  end

  def request_image_helper(picture)
    link_to(cl_image_tag(picture, height: '50'), picture, target: '_blank')
  end
  
end
