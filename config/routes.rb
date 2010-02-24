ActionController::Routing::Routes.draw do |map|
  map.resources :documents
  map.search '/search/:q.:format', :controller => :documents, :action => :search
  map.root :controller => :documents
end