require 'puma'
require 'sinatra'
configure { set :server, :puma }
require 'json'

get '/widget_charts' do
  content_type :json
  @data = {}
  @array = []
  WidgeCharts = Struct.new(:widget)
  WidgeChart = Struct.new(:chart_type, :chart_data)
  @charts = WidgeCharts.new(
    [
      WidgeChart.new('spline', [
                       ['data1', 30, 200, 100, 400, 150, 250],
                       ['data2', 50, 20, 10, 40, 15, 25]
                     ]).to_h,
      WidgeChart.new('bar', [
                       ['data1', 30, 200, 100, 400, 150, 250],
                       ['data2', 130, 100, 140, 200, 150, 50]
                     ]).to_h,

      WidgeChart.new('line', [
                       ['data1', 30, 200, 100, 400, 150, 250],
                       ['data2', 50, 20, 10, 40, 15, 25]
                     ]).to_h
    ]
  )
  @data = { data: @charts.widget }
  @data.to_json
end
