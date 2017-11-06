require 'puma'
require 'sinatra'
configure { set :server, :puma }
require 'json'
require 'byebug'
require 'faker'
require 'date'

get '/widget_charts/v1' do
  content_type :json
  @data = {}
  @array = []
  modem_array = []
  modem_names = []
  dates = []
  modem_names_array = []
  WidgeCharts = Struct.new(:widget)
  WidgeChart = Struct.new(:chart_type, :chart_data, :modem_name, :filters)
  modem_count = 5
  type = params[:chart_type]

  current_date = Faker::Date.backward(14)

  available_date = Faker::Date.backward(30)
  date_range = ((current_date + 7) - current_date).to_i

  modem_count.times do |index|
    modem = Faker::App.name
    modem_array << [modem.to_s]
    date_range.times do
      modem_array.at(index) << rand(600)
    end
    modem_names << modem.to_s
  end

  modem_names.each do |name|
    hash = { name: name }
    modem_names_array << hash
  end

  filters =
    [
      {
        title: 'date_filter',
        type: 'date',
        current_start_date: current_date,
        current_end_date: current_date + 7,
        available_start: available_date,
        available_end: available_date + 30
      },
      {
        title: 'modems',
        type: 'multi-select',
        collection: modem_names_array
      }
    ]

  @charts = WidgeCharts.new(
    [
      WidgeChart.new(type,
                     modem_array,
                     modem_names,
                     filters).to_h
    ]
  )
  @data = { data: @charts.widget }
  @data.to_json
end

get '/widget_charts' do
  modem_names = []

  params[:modem].each do |modem_name|
    modem_names << modem_name
  end
  modem_count = modem_names.count

  start_date = Date.parse(params[:startDate])
  end_date = Date.parse(params[:endDate])

  date_range = (end_date - start_date).to_i
  type = params[:chart_type]

  content_type :json

  @data = {}
  @array = []
  WidgeCharts = Struct.new(:widget)
  WidgeChart = Struct.new(:chart_type, :chart_data, :modem_name, :filters)
  modem_array = []
  dates = []
  modem_names_array = []

  modem_names.each do |name|
    modem_array << [name]
  end

  modem_count.times do |index|
    date_range.times do
      modem_array.at(index) << rand(600)
    end
  end

  date_range.times do
    hash = { value: Faker::Date.between(end_date, start_date).strftime('%d-%m-%Y') }
    dates << hash
  end

  modem_names.each do |name|
    hash = { name: name }
    modem_names_array << hash
  end

  filters = [
    {
      title: 'date_filter',
      type: 'date',
      collection: dates
    },
    {
      title: 'modems',
      type: 'multi-select',
      collection: modem_names_array
    }
  ]

  @charts = WidgeCharts.new(
    [
      WidgeChart.new(type,
                     modem_array,
                     modem_names,
                     filters).to_h
    ]
  )
  @data = { data: @charts.widget }
  @data.to_json
end

get '/widget_charts/v2' do
  content_type :json
  @data = {}
  @array = []
  dates = []
  modem_array = []
  modem_name = []
  sort_date = []
  WidgeCharts = Struct.new(:widget)
  WidgeChart = Struct.new(:data)
  type = 'pie'

  if params[:startDate] && params[:endDate]
    start_date = Date.parse(params[:startDate])
    end_date = Date.parse(params[:endDate])

    date_range = (end_date - start_date).to_i

    date_range.times do
      sort_date << Faker::Date.unique.between(end_date, start_date).strftime('%Y-%m-%d %H:%M')
    end
  end
  Faker::Date.unique.clear

  sort_date.sort.each do |date|
    hash = { value: date }
    dates << hash
  end

  name = Faker::App.name

  5.times do |index|
    modem = Faker::App.name
    hash = { name: modem }
    modem_name << hash
    modem_array << [modem.to_s]
    5.times do
      modem_array.at(index) << rand(600)
    end
  end

  filters = {
    date_filter: {
      start_date: sort_date.sort[0],
      end_date: sort_date.sort[sort_date.count - 1],
      title: 'date_filter',
      type: 'date',
      collection: dates
    },
    multi_select: {
      title: 'modems',
      type: 'multi-select',
      collection: modem_name
    }
  }
  result = {
    columns:  modem_array,
    type: type,
    name: name,
    xFormat: '%Y-%m-5d %H:%M',
    filters: filters
  }

  @charts = WidgeCharts.new(
    WidgeChart.new(result).to_h
  )
  @charts.widget[:data].to_json
end
