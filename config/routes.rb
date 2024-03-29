Rails.application.routes.draw do
  resources :users, only: [:create] do
    resources :accounts, only: [:create]
  end
  
  post '/users/:user_id/accounts/:currency/deposit', to: 'accounts#deposit'
  post 'users/:user_id/accounts/:currency/transfer', to: 'accounts#transfer'

  get 'accounts/deposit_statement',     to: 'accounts#deposit_statement'
  get 'accounts/min_avg_max_statement', to: 'accounts#min_avg_max_statement'
end
