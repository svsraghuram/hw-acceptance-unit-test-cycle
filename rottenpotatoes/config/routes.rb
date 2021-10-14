Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root 'movies#index'
  get 'movies/:id/similar' => 'movies#similar', as: :similar_movies
end