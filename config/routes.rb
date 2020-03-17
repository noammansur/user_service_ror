# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[index show create update]
  post '/sign_in' => 'sessions#create'
  post '/sign_out' => 'sessions#destroy'
end
