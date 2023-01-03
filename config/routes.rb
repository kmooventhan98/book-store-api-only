Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # namespace :v1 , path: 'version_1' do
  namespace :api do
    namespace :v1 do
      resources :books, only: %i[index create destroy]
      post 'authenticate', to: 'authentication#create'
    end
  end
end
