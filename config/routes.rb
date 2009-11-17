ActionController::Routing::Routes.draw do |map|
  map.resources :documents, :collection => { :search => :get }
  map.root :controller => :documents
end
