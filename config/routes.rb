Rails.application.routes.draw do
  resources :courses do
    resources :lessons,except: [:index, :show], controller:"courses/lessons"
    member do
      patch :generate_lessons
    end
  end

  resources :services
  resources :classrooms
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'}

  resources :users, only: [:index, :show, :destroy, :edit, :update] do
    member do
      patch :ban
      patch :resend_confirmation_instructions
      patch :resend_invitaion

    end
  end
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root 'static_pages#landing_page'
  get 'privacy_policy', to:'static_pages#privacy_policy'
  get 'calender', to:'static_pages#calender'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
