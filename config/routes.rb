Rails.application.routes.draw do
  authenticated do
    root 'expenditures#index'
  end

  root 'pages#welcome'

  resources :expenditures

  devise_for :users,
    controllers: { registrations: 'registrations' },
    skip: [:session, :registration]

  as :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session

    get 'signup', to: 'registrations#new', as: :new_user_registration
    post 'signup', to: 'registrations#create', as: :user_registration
    get 'profile', to: 'registrations#edit', as: :edit_user_registration
    put 'profile', to: 'registrations#update'
    delete 'profile', to: 'registrations#destroy'
  end
end
