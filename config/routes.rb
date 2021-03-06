require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json }, path: '/api'  do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update, :destroy]
      post '/sessions', to: 'sessions#create'
      delete '/sessions', to: 'sessions#destroy'
      resources :disciplines, only: [:show, :index] do
        resources :events, only: [:show, :index, :create, :update, :destroy] do
          resources :messages, only: [:index, :create, :update, :destroy]
          resources :votes, only: [:create]
          resources :contenders, only: [:update, :show]
          resources :comments, only: [:create, :destroy, :index]
        end
      end
    end
  end
end
