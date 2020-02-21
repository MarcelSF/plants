Rails.application.routes.draw do
  resources :gardens do
    resources :plants, only: [:create]
  end

  resources :plants, only: :destroy

  resources :plants, only:[] do
    resources :plant_tags, only:[:new, :create]
  end
end
