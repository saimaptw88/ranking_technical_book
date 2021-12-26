Rails.application.routes.draw do
  namespace :v1 do
    resources :home, only: [:index, :show]

    namespace :ranking do
      resources :title, only: [:index]
    end
  end
end
