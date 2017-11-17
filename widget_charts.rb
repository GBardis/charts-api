require 'puma'
require 'sinatra'
configure { set :server, :puma }
require 'json'
require 'byebug'
require 'faker'
require 'date'
require 'active_support/all'


WidgeCharts = Struct.new(:widget)
WidgeChart = Struct.new(:data)
post '/widget_charts/v2' do
  content_type :json
  @data = {}
  @array = []
  dates = []
  modem_array = []
  modem_name = []
  sort_date = []

  type = 'spline'
  # multi_select_params = params.except("end_date","start_date")
  if !params["multi-select\u0000"].nil?
    modem_params_array = params[multi_select_params.keys.first.to_s]
    modem_count = modem_params_array.count

  else
    modem_count = 0
  end

  valid_start_date = Date.parse('1-10-2015')
  valid_end_date = Date.parse('31-10-2015')

  if !params[:start_date].blank? && !params[:end_date].blank?
    # byebug
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    date_range = (end_date - start_date).to_i

    date_range.times do
      sort_date << Faker::Date.unique.between(end_date, start_date).strftime('%Y-%m-%d %H:%M')
    end
  else
    start_date = valid_start_date
    end_date = valid_end_date

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
  id = (1..5).to_a.shuffle

  name = Faker::App.name
  if modem_count.zero?
    5.times do |index|
      modem = Faker::App.name
      new_id = id.pop
      hash = { id: new_id, name: modem }
      modem_name << hash
      modem_array << [modem.to_s]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  else
    modem_params_array.each_with_index do |modem, index|
      new_id = id.pop
      modem_name << { id: new_id, name: modem }
      modem_array << [modem]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  end
  ####second multi-select
  books= []
  id = (1..5).to_a.shuffle
  if modem_count.zero?
    5.times do |index|
      modem = Faker::Book.title
      new_id = id.pop
      hash = { id: new_id, name: modem }
      books << hash
      modem_array << [modem.to_s]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  else
    modem_params_array.each_with_index do |modem, index|
      new_id = id.pop
      books << { id: new_id, name: modem }
      modem_array << [modem]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  end
  ### third multi-select  #######
  company= []
  id = (1..5).to_a.shuffle
  if modem_count.zero?
    5.times do |index|
      modem = Faker::Company.name
      new_id = id.pop
      hash = { id: new_id, name: modem }
      company << hash
      modem_array << [modem.to_s]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  else
    modem_params_array.each_with_index do |modem, index|
      new_id = id.pop
      company << { id: new_id, name: modem }
      modem_array << [modem]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  end

  filters = [
    {
      dataset:
      [
        { start_date: sort_date.sort[0], param_name: 'start_date' },
        { end_date: sort_date.sort[sort_date.count - 1], param_name: 'end_date' },
        { valid_start_date: valid_start_date, param_name: 'valid_start_date' },
        { valid_end_date: valid_end_date, param_name: 'valid_end_date' },

      ],
      title: 'date_filter',
      type: 'datepicker'
    },
    {
      dataset:
      [
        { available_collection: modem_name, param_name: 'modems' }
      ],
      type: 'multi-select',
      title: 'modems'
    },
    {
      dataset:
      [
        { available_collection: books, param_name: 'books' }
      ],
      type: 'multi-select',
      title: 'books'
    },
    {
      dataset:
      [
        { available_collection: company, param_name: 'company' }
      ],
      type: 'multi-select',
      title: 'company'
    },
  ]

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
get '/widget_charts/v2' do
  content_type :json
  @data = {}
  @array = []
  dates = []
  modem_array = []
  modem_name = []
  sort_date = []

  type = 'spline'
  # multi_select_params = params.except("end_date","start_date")
  if !params["multi-select\u0000"].nil?
    modem_params_array = params[multi_select_params.keys.first.to_s]
    modem_count = modem_params_array.count

  else
    modem_count = 0
  end

  valid_start_date = Date.parse('1-10-2015')
  valid_end_date = Date.parse('31-10-2015')

  if !params[:start_date].blank? && !params[:end_date].blank?
    # byebug
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    date_range = (end_date - start_date).to_i

    date_range.times do
      sort_date << Faker::Date.unique.between(end_date, start_date).strftime('%Y-%m-%d %H:%M')
    end
  else
    start_date = valid_start_date
    end_date = valid_end_date

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
  id = (1..5).to_a.shuffle

  name = Faker::App.name
  if modem_count.zero?
    5.times do |index|
      modem = Faker::App.name
      new_id = id.pop
      hash = { id: new_id, name: modem }
      modem_name << hash
      modem_array << [modem.to_s]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  else
    modem_params_array.each_with_index do |modem, index|
      new_id = id.pop
      modem_name << { id: new_id, name: modem }
      modem_array << [modem]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  end
  ####second multi-select
  modem_name_2= []
  id = (1..5).to_a.shuffle
  if modem_count.zero?
    5.times do |index|
      modem = Faker::Book.title
      new_id = id.pop
      hash = { id: new_id, name: modem }
      modem_name_2 << hash
      modem_array << [modem.to_s]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  else
    modem_params_array.each_with_index do |modem, index|
      new_id = id.pop
      modem_name_2 << { id: new_id, name: modem }
      modem_array << [modem]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  end

  filters = [
    {
      dataset:
      [
        { start_date: sort_date.sort[0], param_name: 'start_date' },
        { end_date: sort_date.sort[sort_date.count - 1], param_name: 'end_date' },
        { valid_start_date: valid_start_date, param_name: 'valid_start_date' },
        { valid_end_date: valid_end_date, param_name: 'valid_end_date' }

      ],
      title: 'date_filter',
      type: 'datepicker'
    },
    {
      dataset:
      [
        { available_collection: modem_name, param_name: 'multi-select' }
      ],
      type: 'multi-select',
      title: 'modems'
    },
    {
      dataset:
      [
        { available_collection: modem_name, param_name: 'multi-select' }
      ],
      type: 'multi-select',
      title: 'countries'
    },
    {
      dataset:
      [
        { available_collection: modem_name, param_name: 'multi-select' }
      ],
      type: 'multi-select',
      title: 'ships'
    }
    # ,
    # {
    #   dataset:
    #   [
    #     { available_collection: modem_name_2, param_name: 'multi-select-2' }
    #   ],
    #   type: 'multi-select',
    #   title: 'modems'
    # }
  ]

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



post '/widget_charts/v3' do
  content_type :json
  @data = {}
  @array = []
  dates = []
  modem_array = []
  modem_name = []
  sort_date = []

  type = 'spline'
  # multi_select_params = params.except("end_date","start_date")
  if !params["multi-select\u0000"].nil?
    modem_params_array = params[multi_select_params.keys.first.to_s]
    modem_count = modem_params_array.count

  else
    modem_count = 0
  end

  valid_start_date = Date.parse('1-10-2015')
  valid_end_date = Date.parse('31-10-2015')

  if !params[:start_date].blank? && !params[:end_date].blank?
    # byebug
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    date_range = (end_date - start_date).to_i

    date_range.times do
      sort_date << Faker::Date.unique.between(end_date, start_date).strftime('%Y-%m-%d %H:%M')
    end
  else
    start_date = valid_start_date
    end_date = valid_end_date

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
  id = (1..5).to_a.shuffle

  name = Faker::App.name
  if modem_count.zero?
    5.times do |index|
      modem = Faker::App.name
      new_id = id.pop
      hash = { id: new_id, name: modem }
      modem_name << hash
      modem_array << [modem.to_s]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  else
    modem_params_array.each_with_index do |modem, index|
      new_id = id.pop
      modem_name << { id: new_id, name: modem }
      modem_array << [modem]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  end
  ####second multi-select
  books= []
  id = (1..5).to_a.shuffle
  if modem_count.zero?
    5.times do |index|
      modem = Faker::Book.title
      new_id = id.pop
      hash = { id: new_id, name: modem }
      books << hash
      modem_array << [modem.to_s]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  else
    modem_params_array.each_with_index do |modem, index|
      new_id = id.pop
      books << { id: new_id, name: modem }
      modem_array << [modem]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  end
  ### third multi-select  #######
  company= []
  id = (1..5).to_a.shuffle
  if modem_count.zero?
    5.times do |index|
      modem = Faker::Company.name
      new_id = id.pop
      hash = { id: new_id, name: modem }
      company << hash
      modem_array << [modem.to_s]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  else
    modem_params_array.each_with_index do |modem, index|
      new_id = id.pop
      company << { id: new_id, name: modem }
      modem_array << [modem]
      date_range.times do
        modem_array.at(index) << rand(600)
      end
    end
  end

  filters = [
    {
      dataset:
      [
        { start_date: sort_date.sort[0], param_name: 'startDate' },
        { end_date: sort_date.sort[sort_date.count - 1], param_name: 'endDate' },
        { valid_start_date: valid_start_date, param_name: 'valid_start_date' },
        { valid_end_date: valid_end_date, param_name: 'valid_end_date' },
        title: 'date_filter'
      ],
      type: 'datepicker'
    },
    {
      dataset:
      [
        { available_collection: modem_name, param_name: 'modems' }
      ],
      type: 'multi-select',
      title: 'modems'
    },
    {
      dataset:
      [
        { available_collection: books, param_name: 'books' }
      ],
      type: 'multi-select',
      title: 'books'
    },
    {
      dataset:
      [
        { available_collection: company, param_name: 'company' }
      ],
      type: 'multi-select',
      title: 'company'
    },
  ]

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
# get '/widget_charts/v3' do
#   content_type :json
#   @data = {}
#   @array = []
#   dates = []
#   modem_array = []
#   modem_name = []
#   sort_date = []
#
#   type = 'spline'
#   # multi_select_params = params.except("end_date","start_date")
#   if !params["multi-select\u0000"].nil?
#     modem_params_array = params[multi_select_params.keys.first.to_s]
#     modem_count = modem_params_array.count
#
#   else
#     modem_count = 0
#   end
#
#   valid_start_date = Date.parse('1-10-2015')
#   valid_end_date = Date.parse('31-10-2015')
#
#   if !params[:start_date].blank? && !params[:end_date].blank?
#     # byebug
#     start_date = Date.parse(params[:start_date])
#     end_date = Date.parse(params[:end_date])
#
#     date_range = (end_date - start_date).to_i
#
#     date_range.times do
#       sort_date << Faker::Date.unique.between(end_date, start_date).strftime('%Y-%m-%d %H:%M')
#     end
#   else
#     start_date = valid_start_date
#     end_date = valid_end_date
#
#     date_range = (end_date - start_date).to_i
#
#     date_range.times do
#       sort_date << Faker::Date.unique.between(end_date, start_date).strftime('%Y-%m-%d %H:%M')
#     end
#   end
#   Faker::Date.unique.clear
#
#   sort_date.sort.each do |date|
#     hash = { value: date }
#     dates << hash
#   end
#   id = (1..5).to_a.shuffle
#
#   name = Faker::App.name
#   if modem_count.zero?
#     5.times do |index|
#       modem = Faker::App.name
#       new_id = id.pop
#       hash = { id: new_id, name: modem }
#       modem_name << hash
#       modem_array << [modem.to_s]
#       date_range.times do
#         modem_array.at(index) << rand(600)
#       end
#     end
#   else
#     modem_params_array.each_with_index do |modem, index|
#       new_id = id.pop
#       modem_name << { id: new_id, name: modem }
#       modem_array << [modem]
#       date_range.times do
#         modem_array.at(index) << rand(600)
#       end
#     end
#   end
#   ####second multi-select
#   modem_name_2= []
#   id = (1..5).to_a.shuffle
#   if modem_count.zero?
#     5.times do |index|
#       modem = Faker::Book.title
#       new_id = id.pop
#       hash = { id: new_id, name: modem }
#       modem_name_2 << hash
#       modem_array << [modem.to_s]
#       date_range.times do
#         modem_array.at(index) << rand(600)
#       end
#     end
#   else
#     modem_params_array.each_with_index do |modem, index|
#       new_id = id.pop
#       modem_name_2 << { id: new_id, name: modem }
#       modem_array << [modem]
#       date_range.times do
#         modem_array.at(index) << rand(600)
#       end
#     end
#   end
#
#   filters = [
#     {
#       dataset:
#       [
#         { start_date: sort_date.sort[0], param_name: 'start_date' },
#         { end_date: sort_date.sort[sort_date.count - 1], param_name: 'end_date' },
#         { valid_start_date: valid_start_date, param_name: 'valid_start_date' },
#         { valid_end_date: valid_end_date, param_name: 'valid_end_date' },
#         title: 'date_filter'
#       ],
#       type: 'datepicker'
#     },
#     {
#       dataset:
#       [
#         { available_collection: modem_name, param_name: 'multi-select' }
#       ],
#       type: 'multi-select',
#       title: 'modems'
#     }
#     # ,
#     # {
#     #   dataset:
#     #   [
#     #     { available_collection: modem_name_2, param_name: 'multi-select-2' }
#     #   ],
#     #   type: 'multi-select',
#     #   title: 'modems'
#     # }
#   ]
#
#   result = {
#     columns:  modem_array,
#     type: type,
#     name: name,
#     xFormat: '%Y-%m-5d %H:%M',
#     filters: filters
#   }
#
#   @charts = WidgeCharts.new(
#     WidgeChart.new(result).to_h
#   )
#   @charts.widget[:data].to_json
# end
