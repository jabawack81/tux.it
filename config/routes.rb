TuxItR3::Application.routes.draw do
  
  root :to => "root#index"
  
  match "/new" => "root#create"

  match ":mini.show" => "root#show", :as => :minified  
  match ":mini.info" => "root#info", :as => :info  
  match ":mini.qr" => "root#qr", :as => :qr
  
  match ":mini" => "root#mini"
  
end
