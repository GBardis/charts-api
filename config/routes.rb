Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/widget_charts/v4', to: 'application#v4'
  # put '/widget_charts/v4', to: 'application#v4'
end