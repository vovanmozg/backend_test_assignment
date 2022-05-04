Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/api/v1/recommended_cars', to: 'recommended_cars#index'
end
