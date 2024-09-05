Rails.application.routes.draw do
  devise_for :users

  resources :tasks do
    resources :comments, only: [:new, :create, :update, :destroy, :edit, :show]
  end

  # get 'tasks/:task_id/comments/new', to: 'comments#new', as: :new_task_comment

  root to: 'tasks#index'
end
