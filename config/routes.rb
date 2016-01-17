Rails.application.routes.draw do

  resources :drugs, only: [:index]
  resources :forms, only: [:index]

  post '/pa_required' => 'formularies#pa_required'

  resources :users do
    post :cancel_registration, on: :member
    resources :credentials
  end

  get '/login/:role_description' => 'users#login', as: :demo_login, constraints: { role_description: /(doctor|staff)/ }
  get '/login/:id' => 'users#login', as: :login

  get '/logout' => 'users#logout'

  resources :patients do
    resources :prescriptions do
      resources :pa_requests
    end
  end

  resources :pa_requests do
    member do
      get 'pages', to: 'request_pages#index'
      post 'pages/:button_title',
        to: 'request_pages#action', as: 'action'
    end
  end

  resources :alerts

  # post '/pa_requests/:pa_request_id/request_pages/:button_title',
  #   to: 'request_pages#do_action',
  #   as: :pa_request_request_pages_action

  get '/toggle_ui', to: 'home#toggle_custom_ui'

  get '/dashboard' => 'pa_requests#index'

  get '/help' => 'home#help'

  get '/api' => redirect("https://developers.covermymeds.com/#overview"),
    as: :api_documentation

  get '/code' => redirect("https://github.com/covermymeds/demo-ehr-rails"),
    as: :source_code

  resources :cmm_callbacks, only: [:create, :index, :show]

  get '/home' => 'home#home', as: :home
  put '/home/change_api_env' => 'home#change_api_env'
  get '/home/resetdb' => 'home#reset_database', as: :reset_db

  root 'home#index'


end
