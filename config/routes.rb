Rails.application.routes.draw do
  namespace :v1 do
    resources :home, only: [:index, :show]

    namespace :ranking do
      namespace :total do
        resources :reccomended_book, only: [:index]
        resources :title, only: [:index]
        resources :point, only: [:index]
      end

      namespace :yearly do
        resources :reccomended_book, only: [:index]
        resources :title, only: [:index]
        resources :point, only: [:index]
      end

      namespace :monthly do
        resources :reccomended_book, only: [:index]
        resources :title, only: [:index]
        resources :point, only: [:index]
      end

      resources :title, only: [:index]
      resources :total_point, only: [:index]
    end
  end
end
