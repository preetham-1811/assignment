Rails.application.routes.draw do

  resources :courses
  resources :rooms
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :user

  get 'test/index1'
  get 'test/hello'
  root 'home#mainpage'
  get 'home/mainpage'
  get 'home/assignments'
  get 'home/project'
  get 'home/team'
  get 'ps1/ps1'
  get 'ps1/article'
  get 'ps1/dbz'
  get 'ps2/quotations'
  post 'ps2/quotations'
  get 'ps2/quotationssearch'
  get 'ps2/importxml' => 'ps2#importxml'
  get 'ps2/index'
  get 'ps3/projectplan'
  get 'ps4/usermngmt'
  get 'ps5/contentmngmt'
  get 'ps6/feedback'

  post 'examscheduler/parseSchedule'

  # Routes for exam scheduler
  get 'examscheduler/admin', to: 'examscheduler#admin'
  get 'examscheduler/manage_users', to: 'examscheduler#manage_users'
  get 'examscheduler/manage_users/recently_registered_users', to: 'examscheduler#recently_registered_users'
  get 'examscheduler/ban_users', to: 'examscheduler#ban_users'
  get 'examscheduler/user_stats', to: 'examscheduler#view_stats'
  get 'examscheduler/index'
  get 'examscheduler/fullschedule', to: 'examscheduler#full_schedule'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
