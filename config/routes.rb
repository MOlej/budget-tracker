Rails.application.routes.draw do
  root 'expenditures#index'

  resources :expenditures
end
