Rails.application.routes.draw do
  mount CASino::Engine => '/', :as => 'casino'
  root to: 'visitors#index'
  get '/auth', to: 'visitors#test_auth'
  get '/register', to: 'registration#new', as: 'registration_new'
  post '/register', to: 'registration#create', as: 'registration_create'
  get '/account/confirm_email/:token', to: 'registration#email_confirmation',
                                       as: 'confirm_email'
  get '/account/resend', to: 'registration#new_confirmation',
                         as: 'new_confirmation'
  post 'account/resend', to: 'registration#resend_confirmation',
                         as: 'resend_confirmation'
  get '/account/forgot_pass', to: 'registration#forgot_pass',
                              as: 'forgot_pass'
  get '/account/restore_pass/:token', to: 'registration#restore_pass',
                              as: 'restore_pass'
  post '/account/restore_pass', to: 'registration#send_pass_token',
                                as: 'send_pass_token'
  patch '/account/update_pass', to: 'registration#update',
                               as: 'update_password'
end
