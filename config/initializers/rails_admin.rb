# frozen_string_literal: true

RailsAdmin.config do |config|
  config.asset_source = :sprockets
  config.navigation_static_links = {
    'TimeSheet' => '/time_sheets',
    'Attachments' => '/attachments',
    'Leave Section' => '/admins/leave_section'
  }

  # config.model 'TimeSheet' do
  # ,target: "_self"
  #   list do
  #     #field :user do
  #       TimeSheet.joins(:user).pluck(:user_id).uniq
  #       #TimeSheet.select('DISTINCT user')
  #       #User.pluck(:time_sheets).uniq
  #       #TimeSheet.pluck("DISTINCT user")
  #       #TimeSheet.uniq(&:user)
  #       #User.joins(:time_sheets)
  #       #TimeSheet.all.order(:user_id, :created_at).to_a.uniq(&:user_id)
  #     #end

  #   end

  # end

  # config.model 'User' do

  #   list do
  #      field :id
  #      field :email
  #      #field :link_to time_sheets_path
  #      field :reset_password_sent_at
  #      field :remember_created_at
  #      field :created_at
  #      field :updated_at
  #      field :role

  #   end

  # end

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
  config.authorize_with do
    redirect_to main_app.root_path flash[:notice] = 'You are not admin' unless current_user.super_admin? 
  end
  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
