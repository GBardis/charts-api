Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/widget_charts/v3', to: 'application#v3'
  post '/widget_charts/v4', to: 'application#v4'
  post '/widget_charts/v5', to: 'application#v5'
  post '/widget_charts/v6', to: 'application#v6'
end
