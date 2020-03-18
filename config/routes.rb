# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[index show create update]
  post '/sign_in' => 'users#sign_in'
  post '/sign_out' => 'users#sign_out'
end
