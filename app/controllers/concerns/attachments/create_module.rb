# frozen_string_literal: true

# concerns/attachments/create_module.rb
module Attachments
  module CreateModule
    include ActiveSupport::Concern

    def create_attachment_part
      @attachment.save
    rescue ActiveStorage::IntegrityError => e
      rescue_block
    else
      rescue_else_block
    end

    def rescue_block
      respond_to do |format|
        format.html { redirect_to attachments_path, notice: 'Attachment was successfully created.' }
      end
    end

    def rescue_else_block
      if @attachment.save
        respond_to do |format|
          format.html { redirect_to attachments_path, notice: 'Attachment was successfully created.' }
        end
      else
        rescue_else_block_else_part
      end
    end

    def rescue_else_block_else_part
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end
end
