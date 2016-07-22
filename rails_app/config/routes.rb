Rails.application.routes.draw do
  resources :tweets
  resources :users

  root 'home#index', as: 'home'
  get '/foo' => 'home#foo', as: 'foo'
  get '/bar' => 'home#bar', as: 'bar'
end
