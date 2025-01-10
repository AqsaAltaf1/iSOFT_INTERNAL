json.extract! request, :id, :details, :request_type, :user_id, :company_id, :created_at, :updated_at
json.url request_url(request, format: :json)
