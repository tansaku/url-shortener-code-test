Rails.application.routes.draw do
  get 'url_shortener/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'url_shortener#index', via: [:post]

  get '*path', to: 'url_shortener#redirect'
end
