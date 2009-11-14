ActionController::Routing::Routes.draw do |map|
  map.resources :documents, :collection => { :search => :get }
end
