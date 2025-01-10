json.extract! location, :id, :work_location, :country, :state, :city, :zip_code, :address, :created_at, :updated_at
json.url location_url(location, format: :json)
