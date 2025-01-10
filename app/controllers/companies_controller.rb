# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :set_company, only: %i[edit show update destroy]

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.create(company_params)
    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_path, notice: 'Company is successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to companies_path, notice: 'Company is successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_path, notice: 'Company is successfully destroyed.' }
    end
  end

  def generate_token
    payload = { 
      company_id: current_user.company.id,
      exp: 24.hours.from_now.to_i
    }
    secret_key = ENV['JWT_SECRET_KEY']
    token = JWT.encode(payload, secret_key, 'HS256')
    current_user.company.update(auth_token: token)  
    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream:
            turbo_stream.update('auth_token',
                                  partial: 'home/authentication_token'
                                )
      }
      format.html
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :subdomain, :avatar, :status)
  end

  def set_company
    @company = Company.find(params[:id])
  end
end
