require 'puma'
require 'sinatra'
configure { set :server, :puma }
require 'json'
require 'byebug'
require 'faker'

get '/widget_charts' do

  start_date = Date.parse(params[:startDate])
  end_date = Date.parse(params[:endDate])

  date_range = (end_date - start_date).to_i
  modem_count = params[:modem].to_i
  type = params[:chart_type]

  datapoint_count = if params[:datapoint_count]
    params[:datapoint_count].to_i
  else
    4
  end
  content_type :json
  @data = {}
  @array = []
  WidgeCharts = Struct.new(:widget)
  WidgeChart = Struct.new(:chart_type, :count, :chart_data, :modem_name, :filters)
  modem_array = []
  modem_names = []

  unless datapoint_count.nil?
    modem_count.times do |index|
      modem = Faker::App.name
      modem_array << [modem.to_s]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
      modem_names << modem.to_s
    end

    filters = [
      {
        title:"date_filter",
        type:"date",
        collection:[
          4.times do |value|
            {
            value:  Faker::Date.between(end_date,start_date).strftime('%d-%m-%Y').to_s 
            }
          end
        ]
      },
      {
        title:"modems",
        type:"multi-select",
        collection:[
          modem_names.each do |name|
            {
              "name": name
            }
          end
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
