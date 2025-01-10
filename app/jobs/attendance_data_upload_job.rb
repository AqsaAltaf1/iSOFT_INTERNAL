class AttendanceDataUploadJob < ApplicationJob
  queue_as :default

  def perform(data)
    delete_existing_files
    json_data = data.to_json
    file_path = Rails.root.join('tmp', "attendance_data.json")
    File.open(file_path, 'w') do |file|
      file.write(json_data)
    end
    puts "File content: #{File.read(file_path)}"
    response = Cloudinary::Uploader.upload(file_path.to_s, resource_type: :raw, public_id: "attendance_data", use_filename: true, format: 'txt')
    File.delete(file_path) if File.exist?(file_path)
    response['url']
  rescue Cloudinary::Api::Error => e
    raise e
  rescue => e
    raise e
  end

  private

  def delete_existing_files
    begin
      results = Cloudinary::Api.resources(type: :upload, prefix: 'attendance_data', resource_type: :raw)
      results['resources'].each do |resource|
        Cloudinary::Uploader.destroy(resource['public_id'], resource_type: :raw)
      end
    rescue Cloudinary::Api::Error => e
      puts "Error deleting existing files: #{e.message}"
      raise e
    rescue => e
      puts "General error deleting existing files: #{e.message}"
      raise e
    end
  end
end


