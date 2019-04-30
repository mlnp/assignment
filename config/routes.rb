Rails.application.routes.draw do
  # MLNP URL shortener endpoints
  post '/urls/', to: 'urls#create'
  get '/:code', to: 'urls#show'
  get '/:code/stats', to: 'urls#stats'
end
