json.extract! employee_group, :id, :code, :name, :description, :company_id, :created_at, :updated_at
json.url employee_group_url(employee_group, format: :json)
