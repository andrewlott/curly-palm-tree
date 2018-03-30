Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    root :to => 'devise/registrations#edit'
  end

  get '/photo', to: 'photo#photo'
  get '/callback', to: 'photo#callback'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
