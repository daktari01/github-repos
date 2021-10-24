Rails.application.routes.draw do
  root 'github_results#index'
  get 'github_results/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
