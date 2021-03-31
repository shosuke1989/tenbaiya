Rails.application.routes.draw do
  get 'posts/index' => "posts#index"
  post 'posts/index' => "posts#index"
  get"posts/new" => "posts#new"
  

  get "posts/find" => "posts#find"
  post "posts/findticket" => "posts#findticket"

  get "posts/:id" => "posts#show"


  post "posts/:id/sending" => "posts#sending"
  get "posts/:id/:phonenumber/:buy_id/check" => "posts#check"
  post "posts/:id/:phonenumber/:ticket_id/input" => "posts#input"
  get "posts/:id/ticket" => "posts#ticket"
  post "posts/:id/used" => "posts#used"

 
  post "posts/create" => "posts#create"


  get '/' => "home#top"
  get 'about' => "home#about"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
