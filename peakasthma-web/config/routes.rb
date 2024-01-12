Rails.application.routes.draw do

  get 'twilio_messages/reply'
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  mount Avocado::Engine => '/avocado'

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' },
                     :controllers => {:confirmations => 'confirmations'}
  devise_scope :user do
    put "/confirm" => "confirmations#confirm"
  end

  namespace :api, defaults: { format: :json } do
    devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }

    get 'users/current', to: 'users#current'
    post 'users/accept_policy', to: 'users#accept_policy'
    get 'tip', to: 'tips#get_tip'
    post 'weather', to: 'tips#get_weather'
    post 'video', to: 'videos#likeVideo'
    get 'video', to: 'videos#avbVideo'
    get 'medicationreminder/:minutes/:color', to: 'taken_prescription_records#reminder_later'
    get 'incentive', to: 'incentive#incentive'
    get 'survey', to: 'survey#survey'
    post 'clincard_balance_request', to: 'clincard_balance_requests#send_request'
    resources :activities, only: [:index]
    resources :peak_flows, only: [:create, :index]
    resources :prescriptions, only: [:index] do
      post :notifications, on: :collection
      post :reports, on: :collection
      post :remindmelater, on: :collection
    end
    resources :symptoms, only: [:index]
    resources :read_notification_records, only: [:create]
    resources :taken_prescription_records, only: [:create]
    resources :notifications, only: [:index]

    namespace :control, defaults: { format: :json } do
      get 'users/current', to: 'users#current'
      post 'users/accept_policy', to: 'users#accept_policy'
      resources :activities, only: [:index]
      resources :diet_records, only: [:create, :index, :update]
      resources :notifications, only: [:index]
      post 'daily_reminder', to: 'notifications#daily_reminder'
      resources :read_notification_records, only: [:create]
      get 'incentive', to: 'incentive#incentive'
      get 'control_survey', to: 'control_survey#survey'
      post 'clincard_balance_request', to: 'clincard_balance_requests#send_request'
    end
  end
  
  resources :users do
    post :create_admin, on: :collection
  end

  resource :twilio_notifications do
    collection do
      post 'reply'
    end
  end
  post 'red_voice', to: 'twilio_notifications#red_voice', defaults: { format: 'xml' }
  post 'yellow_voice', to: 'twilio_notifications#yellow_voice', defaults: { format: 'xml' }
  get 'tip/:id', to: 'tips#send_tip'
  resources :medications
  resources :symptoms
  resources :tips
  resources :videos
  resources :exacerbations
  resources :patient_reward_records
  resources :control_patient_reward_records
  resources :patient_visits_records
  resources :control_patient_visits_records
  resources :clincard_balance_requests
  resources :alert_tables
  resources :patients, only: [:index, :show, :edit, :update, :new, :create] do
    resources :peak_flows, only: [:index]
    resources :prescriptions do
      get :fields, on: :collection
      resources :prescription_refill_records
    end
    resources :prescriptions
    resources :notifications do
      get :fields, on: :collection
    end
    resources :guardians
    resources :reports, only: [:show]
  end
  resources :notifications, only: [:index, :create, :edit, :update, :new, :destroy] do
    get :fields, on: :collection
  end

  resources :control_patients, only: [:index, :show, :edit, :update, :new, :create] do
    resources :control_notifications
  end
  resources :control_notifications, only: [:index, :create, :edit, :update, :new, :destroy]
  root to: 'dashboard#root'
end

