require 'puma'
require 'sinatra'
configure { set :server, :puma }
require 'json'
require 'byebug'
require 'faker'

get '/widget_charts' do
  modem_count = params[:modem].to_i
  type = params[:chart_type]
  datapoint_count = params[:datapoint_count].to_i
  content_type :json
  @data = {}
  @array = []
  WidgeCharts = Struct.new(:widget)
  WidgeChart = Struct.new(:chart_type, :count, :chart_data, :modem_name, :filters)
  modem_array = []
  modem_names = []

  unless datapoint_count.nil?
    modem_count.times do |index|
      modem = Faker::App.unique.name
      modem_array << [modem.to_s]
      datapoint_count.times do
        modem_array.at(index) << rand(600)
      end
      modem_names << modem.to_s
    end
    filters =
      [
        {
          title: '',
          filter_type: 'checkbox',
          collection: [
            value: '',
            label: 'All'
          ]
        },
        {
          title: '',
          filter_type: 'textbox',
          collection: [
            value: datapoint_count,
            label: 'Datapoints'
          ]
        }
      ]
  end
  @charts = WidgeCharts.new(
    [
      WidgeChart.new(type,
                     modem_count,
                     modem_array,
                     modem_names,
                     filters).to_h
    ]
  )
  @data = { data: @charts.widget }
  @data.to_json
end
