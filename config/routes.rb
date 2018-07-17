Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/widget_charts/v3', to: 'application#v3'
  post '/widget_charts/v4', to: 'application#v4'
  post '/widget_charts/v5', to: 'application#v5'
  post '/widget_charts/timeseries', to: 'application#timeseries'
  post '/widget_charts/bar', to: 'application#bar'
  post '/widget_charts/pie', to: 'application#pie'
  post '/widget_charts/unauthorized', to: 'application#unauthorized'
  post '/widget_charts/unprocessable', to: 'application#unprocessable'
  post '/widget_charts/server_error', to: 'application#server_error'
  post '/widget_charts/origin_error', to: 'application#origin_error'
end
