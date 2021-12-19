Rails.application.routes.draw do
  namespace :v1 do
    resources :home, only: [:index, :show]
  end
end
