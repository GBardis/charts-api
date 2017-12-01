Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/widget_charts/v4', to: 'application#v4'
  post '/widget_charts/v3', to: 'application#v3'
  # put '/widget_charts/v4', to: 'application#v4'
end
