Rails.application.routes.draw do
  root to: "home#index"
  devise_for :students
  resources :reports
  resources :tasks do
    get 'submissions/:id/status' => 'submissions#status'
    resources :submissions
  end
  resources :task_rankings

  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords',
    registrations: 'admins/registrations'
  }

  namespace :manage do
    root :to => 'manage#index'
    get 'export/ac' => 'manage#export_ac'
    get 'export/ta_check' => 'manage#export_tacheck'
    resources :tasks do
      post 'toggle_public' => 'tasks#togglePublic'
      post 'rejudge' => 'tasks#rejudge'
      get 'load_file' => 'test_cases#load_file'
      resources :test_cases
    end
    resources :students do
      resources :submissions
      resources :reports
    end
  end
  get 'pdf/:report_id' => 'pdf#show', as: :preview
end
