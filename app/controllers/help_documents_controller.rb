# frozen_string_literal: true

class HelpDocumentsController < ApplicationController
  before_action :set_help_document, only: %i[show edit update destroy]

  # GET /help_documents or /help_documents.json
  def index
    @help_documents = HelpDocument.includes([file_attachment: :blob]).all
  end

  # GET /help_documents/1 or /help_documents/1.json
  def show; end

  # GET /help_documents/new
  def new
    authorize HelpDocument
    @help_document = HelpDocument.new
  end

  # GET /help_documents/1/edit
  def edit
    authorize HelpDocument
  end

  # POST /help_documents or /help_documents.json
  def create
    authorize HelpDocument
    @help_document = HelpDocument.new(help_document_params)

    respond_to do |format|
      if @help_document.save
        format.html { redirect_to help_documents_path, notice: 'Help document was successfully created.' }
        format.json { render :show, status: :created, location: @help_document }
      else
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @help_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /help_documents/1 or /help_documents/1.json
  def update
    authorize HelpDocument
    respond_to do |format|
      if @help_document.update(help_document_params)
        format.html { redirect_to help_document_url(@help_document), notice: 'Help document was successfully updated.' }
        format.json { render :show, status: :ok, location: @help_document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
        format.json { render json: @help_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /help_documents/1 or /help_documents/1.json
  def destroy
    authorize HelpDocument
    @help_document.destroy

    respond_to do |format|
      format.html { redirect_to help_documents_url, notice: 'Help document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_help_document
    @help_document = HelpDocument.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def help_document_params
    params.require(:help_document).permit(:name, :file)
  end
end
