Rails.application.routes.draw do
  namespace :v1 do
    resources :pay_rates, only: [:create, :update] do
      member do
        get 'payment'
      end
    end
  end
end
