Rails.application.routes.draw do
  resources :articles, only: [:index, :show]
  root to: 'articles#index'
end
