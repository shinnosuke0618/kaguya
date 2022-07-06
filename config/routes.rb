Rails.application.routes.draw do

  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
  }

  #管理者側ルーティング
  namespace :admin do
    root to: "orders#index" #管理者側TOPページ
    resources :items, only: [:index, :new, :create, :show, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders, only: [:index, :show, :update]
    resources :order_details, only: [:update]
  end

  #顧客側ルーティング
  scope module: :public do

  resources :items, only: [:index, :show]
  resources :cart_items, only: [:index, :create, :update, :destroy] do
    collection do
      delete 'destroy_all'
    end
  end

  resources :orders, only: [:new, :create, :index, :show] do
    collection do
      post 'confirm'
    end
    collection do
      get 'thanks'
    end
  end

  get 'customers/unsubscribe' => 'customers#unsubscribe'
  patch 'customers/withdraw' => 'customers#withdraw'

  resource "customers", path: 'customers/my_page', only: [:edit, :show, :update]

  resources :addresses, only: [:index, :create, :edit, :update, :destroy]

  root to: "homes#top"
  get "about" => "homes#about", as: "about"
  end

end
