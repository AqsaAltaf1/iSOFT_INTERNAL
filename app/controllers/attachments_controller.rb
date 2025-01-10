# app/controllers/attachments_controller.rb
# frozen_string_literal: true

# attachment controller for app, to manage user attachments
class AttachmentsController < ApplicationController
  include Attachments::FolderModule
  include Attachments::CreateModule
  include Attachments::DestroyModule

  before_action :authenticate_user!

  def index
    @attachments = if params[:type] == 'Company'
                     Attachment.includes(files_attachments: :blob).filtered_by_current_user(current_user)
                   else
                     current_user.attachments.includes(files_attachments: :blob).by_attachment_type('self')
                   end

    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def new
    @attachment = Attachment.new
    @type = params[:type]
    @employees = User.employees_that_are_not_hrs
  end

  def create
    if attachments_params_employee[:employee]
      user_employee_attachments = User.find(attachments_params_employee[:employee].to_i)
      @attachment = user_employee_attachments.attachments.build(attachments_params)
    else
      @attachment = current_user.attachments.build(attachments_params)
    end
    create_attachment_part
  end

  def folder_view
    folder_view_data
    begin
      zipfile = Tempfile.new('file')
      zip_temp_file(zipfile)
    rescue Exception => e
      @error = e.message
    end
    zipfile_part(zipfile)
  end

  def destroy_multiple
    if params[:files_ids].present?
      @attachments = current_user.attachments
      unless_else_part
      respond_to do |format|
        format.html { redirect_to attachments_url(@attachment), notice: 'Attachment was successfully deleted.' }
        format.json { head :no_content }
      end
    else
      unless_part
    end
  end

  def attachments_params
    params.require(:attachment).permit(:id, :description, :attachment_type, files: [])
  end

  def attachments_params_employee
    params.require(:attachment).permit(:employee)
  end
end
