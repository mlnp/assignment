Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/:code', to: 'urls#show'
  get '/:code/stats', to: 'urls#stats'
  resources :urls, only: [:create]

end
