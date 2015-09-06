Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :languages

  resources :manual_languages


  # You can have the root of your site routed with "root"
  root 'languages#index'
end
