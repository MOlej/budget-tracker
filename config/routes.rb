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
    get 'profile/edit', to: 'registrations#edit', as: :edit_user_registration
    patch 'profile/edit', to: 'registrations#update'
    delete 'profile/edit', to: 'registrations#destroy'
  end

  scope '/profile' do
    resources :user_categories, controller: :categories, only: %i[index create destroy]
  end
 # get 'profile/custom_categories', to: 'categories#user_categories', as: :user_categories
 # post 'profile/custom_categories', to: 'categories#user_categories'
 # match 'profile/custom_categories' => 'categories#users_categories', as: :user_cateogories, via: [:get, :post]
end
