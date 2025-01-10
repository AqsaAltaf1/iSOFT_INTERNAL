# frozen_string_literal: true

Rails.application.routes.draw do
  resources :employee_groups
  resources :attendances
  post 'generate_token', to: 'companies#generate_token'
  resources :user_designations
  resources :shifts
  resources :locations
  resources :departments
  resources :requests
  resources :roles, only: %i[new create edit update show index]
  get 'users/:id/profile_url', to: 'users#profile_url'
  get 'search/search'
  resources :upcoming_holidays
  resources :supports
  resources :help_documents
  resources :company_assets do
    collection do 
      get :user_assets
    end
  end
  resources :apply_leaves
  resources :projects
  resources :announcements
  resources :histories
  resources :evaluations do
    collection do
      post :create_feedback
      get :user_evaluation
      get :employee_evaluation
      get :active_evaluation_status
      get :completed_evaluation
      get :approve_evaluation_status
      get :reject_evaluation_status
    end
  end
  get '/see_all_notifications', to: 'application#see_all_notifications'
  post 'mark_all_notifications_as_read', to: 'application#mark_all_notifications_as_read'
  get '/folder_view', to: 'attachments#folder_view'
  resources :questions
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get 'admins/sheet'
  get 'admins/leave_section'
  get 'admins/data'
  get 'admins/view_attachments'
  get 'admins/view_users'
  get 'admins/attachments_users'
  get 'admins/requests_section'
  get 'admins/all_employee_attendance'
  resources :admins

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :time_sheets do
    collection do
      get :mark_all_notification
      get :see_all_notification
      get :calander_view
    end
  end
  devise_for :users,
             skip: [:registrations],
             controllers: {
               sessions: 'users/sessions'
             }
  devise_scope :user do
    get 'user/sign-up', to: 'users/registrations#new', as: :new_user_registration
    get 'authenticate_from_token', to: 'users/sessions#authenticate_from_token'
  end
  resources :users do
    collection do
      get :report_to
    end
  end

  get '/search', to: 'home#search'
  get 'home/employee'
  get 'home/hr'
  get 'home/admin'
  get 'home/contact_list'
  get 'home/employee_details'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#home'
  resources :attachments do
    collection do
      get :destroy_multiple
    end
  end

  resources :notes

  resources :after_signup
  resources :leaves do
    member do
      get :hours_date
    end
  end

  resources :companies
  # API V1 Authentication Routes
  namespace :api do
    namespace :v1 do
      post 'attendances', to: 'attendances#index'
      resources :attendances
      devise_for :users, controllers: { sessions: 'api/v1/users/sessions', passwords: 'api/v1/passwords' }
      resources :users
      resources :projects
      # API V1 Employee Routes
      namespace :employee do
        resources :time_sheets do
          collection do
            get :timesheet_status
            get :approval_request
          end
        end
        resources :leaves
        resources :attachments
      end
      # API V1 Admin routes
      namespace :admin do
        resources :time_sheets
        resources :leaves
        resources :admins
      end
      # API V1 Hr routes
      namespace :hr do
        resources :time_sheets
        resources :leaves
        # resources :admins
      end
    end
  end
end
