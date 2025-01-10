# frozen_string_literal: true

class RolesController < ApplicationController
  before_action :get_all_permissions, only: %i[new create]
  before_action :set_role, only: %i[show edit update]
  before_action :set_authorization, only: %i[new create edit update index]

  def index 
    @roles = Role.includes([:permissions]).all
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  def edit
  end

  # POST /roless or /roless.json
  def create
    @role = Role.new(role_params)
    @role.company_id = current_user.company.id
    respond_to do |format|
      if @role.save
        format.turbo_stream do 
          render turbo_stream:
            turbo_stream.replace('users_roles',
                                  partial: 'all_roles',
                                  locals: { roles: Role.all })
        end
        format.html { redirect_to new_user_path, data: { turbo_frame: 'remote_modal' } }
        format.json { render :show, status: :created, location: @role }
      else
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.turbo_stream do 
          render turbo_stream:
            turbo_stream.replace('users_roles',
                                  partial: 'all_roles',
                                  locals: { roles: Role.all })
          end
        format.html { redirect_to roles_path }
        format.json { render :show, status: :created, location: @role }
      else
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.

  def get_all_permissions
    @permissions = User.find_by(user_type: "admin").permissions.includes([:rich_text_description]).all.group_by(&:controller)
  end

  def set_role
    @role = Role.find_by(id: params[:id])
    @permissions = User.find_by(user_type: "admin").permissions.includes([:rich_text_description]).all.group_by(&:controller)
  end
  
  def set_authorization
    authorize Role
  end

  def role_params
    params.require(:role).permit(:name, :company_id, permission_ids_input: [])
  end
end
