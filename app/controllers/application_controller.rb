class ApplicationController < ActionController::Base
  # rotect_from_forgery with: :exception
  # skip_before_action :verify_authenticity_token

  WidgeCharts = Struct.new(:widget)
  WidgeChart = Struct.new(:data)
  def filters(params)
    dates = []
    modem_array = []
    modem_name = []
    sort_date = []
    type = if params[:charts_type].nil?
             'spline'
           else
             params[:charts_type]
           end
    # multi_select_params = params.except("end_date","start_date")
    if !params["multi-select\u0000"].nil?
      modem_params_array = params[multi_select_params.keys.first.to_s]
      modem_count = modem_params_array.count

    else
      modem_count = 0
    end
    # byebug
    time_now = Time.now

    valid_start_date = DateTime.new(2015, 10, 1, time_now.hour, time_now.min).strftime '%b %d %Y %H:%M'

    valid_end_date = DateTime.new(2015, 10, 30, time_now.hour, time_now.min).strftime '%b %d %Y %H:%M'

    # byebug
    if !params['start-date'].blank? && !params['end-date'].blank?
      start_date = Date.parse(params['start-date'])
      end_date = Date.parse(params['end-date'])

      date_range = (Date.parse(end_date.to_s) - Date.parse(start_date.to_s)).to_i
      time_now = Time.now
      # byebug
      date_range.times do
        date = Faker::Date.unique.between(end_date, start_date)
        sort_date << Time.new(date.year, date.month, date.day, time_now.hour, time_now.min).strftime('%b %d %Y %H:%M')
      end
    else

      sdate = Date.parse(valid_end_date) - 20
      edate = Date.parse(valid_end_date) - 2
      t = Time.now

      start_date = Time.new(sdate.year, sdate.month, sdate.day, t.hour, t.min).to_s
      end_date = Time.new(edate.year, edate.month, edate.day, t.hour, t.min).to_s

      date_range = (Date.parse(end_date) - Date.parse(start_date)).to_i

      date_range.times do
        date = Faker::Date.unique.between(end_date, start_date)
        sort_date << Time.new(date.year, date.month, date.day, t.hour, t.min).strftime('%b %d %Y %H:%M')
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
    # end
    # ###second multi-select
    books = []
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
    company = []
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
    # ##single-select###
    bank = []
    id = (1..5).to_a
    if modem_count.zero?
      5.times do |index|
        modem = Faker::Bank.name
        new_id = id[index]
        hash = { id: new_id, name: modem }
        bank << hash
        modem_array << [modem.to_s]
        date_range.times do
          modem_array.at(index) << rand(600)
        end
      end
    else
      modem_params_array.each_with_index do |modem, index|
        new_id = id[index]
        bank << { id: new_id, name: modem }
        modem_array << [modem]
        date_range.times do
          modem_array.at(index) << rand(600)
        end
      end
    end

    # ##single-select-2###

    languange = []
    id = (1..5).to_a
    if modem_count.zero?
      5.times do |index|
        modem = Faker::Address.city
        new_id = id[index]
        hash = { id: new_id, name: modem }
        languange << hash
        modem_array << [modem.to_s]
        date_range.times do
          modem_array.at(index) << rand(600)
        end
      end
    else
      modem_params_array.each_with_index do |modem, index|
        new_id = id[index]
        languange << { id: new_id, name: modem }
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
          { start_date: sort_date.sort[0], param_name: 'start-date' },
          { end_date: sort_date.sort[sort_date.count - 1], param_name: 'end-date' },
          { valid_start_date: valid_start_date, param_name: 'valid-start-date' },
          { valid_end_date: valid_end_date, param_name: 'valid-end-date' }

        ],
        title: 'date-filter',
        type: 'date-picker'
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
      {
        dataset:
        [
          { available_collection: bank, param_name: 'banks' }
        ],
        type: 'single-select',
        title: 'bank'
      },
      {
        dataset:
        [
          { available_collection: languange, param_name: 'languanges' }
        ],
        type: 'single-select',
        title: 'languanges'
      }
    ]

    result = {
      columns:  modem_array,
      type: type,
      name: name,
      xFormat: '%Y-%m-5d %H:%M',
      filters: filters
    }
    result
  end

  def v5
    params = JSON.parse(request.body.read)
    # content_type :json
    @data = {}
    @array = []
    result = filters(params)

    @charts = WidgeCharts.new(
      WidgeChart.new(result).to_h
    )
    render json: @charts.widget[:data].to_json
  end

  def v4
    # byebug
    # request.body.read = '{}' if request.body.read.blank?
    params = JSON.parse(request.body.read)
    # content_type :json
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
    # byebug
    valid_start_date = DateTime.new(2015, 10, 1).strftime('%b %d %Y')
    valid_end_date = DateTime.new(2015, 10, 30).strftime('%b %d %Y')

    # byebug
    if !params['start_date'].blank? && !params['end_date'].blank?
      # byebug
      start_date = Date.parse(params['start_date'])
      end_date = Date.parse(params['end_date'])

      date_range = (Date.parse(end_date.to_s) - Date.parse(start_date.to_s)).to_i

      date_range.times do
        sort_date << Faker::Date.unique.between(end_date, start_date).strftime('%b %d %Y')
      end
    else
      start_date = (Date.parse(valid_end_date) - 20).to_s
      end_date = (Date.parse(valid_end_date) - 2).to_s

      date_range = (Date.parse(end_date) - Date.parse(start_date)).to_i

      date_range.times do
        sort_date << Faker::Date.unique.between(end_date, start_date).strftime('%b %d %Y')
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
    # end
    # ###second multi-select
    books = []
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
    company = []
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
    # ##single-select###
    bank = []
    id = (1..5).to_a
    if modem_count.zero?
      5.times do |index|
        modem = Faker::Bank.name
        new_id = id[index]
        hash = { id: new_id, name: modem }
        bank << hash
        modem_array << [modem.to_s]
        date_range.times do
          modem_array.at(index) << rand(600)
        end
      end
    else
      modem_params_array.each_with_index do |modem, index|
        new_id = id[index]
        bank << { id: new_id, name: modem }
        modem_array << [modem]
        date_range.times do
          modem_array.at(index) << rand(600)
        end
      end
    end

    # ##single-select-2###

    languange = []
    id = (1..5).to_a
    if modem_count.zero?
      5.times do |index|
        modem = Faker::Address.city
        new_id = id[index]
        hash = { id: new_id, name: modem }
        languange << hash
        modem_array << [modem.to_s]
        date_range.times do
          modem_array.at(index) << rand(600)
        end
      end
    else
      modem_params_array.each_with_index do |modem, index|
        new_id = id[index]
        languange << { id: new_id, name: modem }
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
        type: 'date-picker'
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
      {
        dataset:
        [
          { available_collection: bank, param_name: 'banks' }
        ],
        type: 'single-select',
        title: 'bank'
      },
      {
        dataset:
        [
          { available_collection: languange, param_name: 'languanges' }
        ],
        type: 'single-select',
        title: 'languanges'
      }
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
    render json: @charts.widget[:data].to_json
  end

  def v3
    # params = JSON.parse(request.body.read)
    # content_type :json
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
    # byebug
    valid_start_date = DateTime.new(2015, 10, 1).strftime('%m-%d-%Y')
    valid_end_date = DateTime.new(2015, 10, 30).strftime('%b %d %Y')

    # byebug
    if !params['start_date'].blank? && !params['end_date'].blank?
      # byebug
      start_date = Date.parse(params['start_date'])
      end_date = Date.parse(params['end_date'])

      date_range = (Date.parse(end_date.to_s) - Date.parse(start_date.to_s)).to_i

      date_range.times do
        sort_date << Faker::Date.unique.between(end_date, start_date).strftime('%b %d %Y')
      end
    else
      start_date = (Date.parse(valid_end_date) - 20).to_s
      end_date = (Date.parse(valid_end_date) - 2).to_s

      date_range = (Date.parse(end_date) - Date.parse(start_date)).to_i

      date_range.times do
        sort_date << Faker::Date.unique.between(end_date, start_date).strftime('%b %d %Y')
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
    # end
    # ###second multi-select
    books = []
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
    company = []
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
    # ##single-select###
    bank = []
    id = (1..5).to_a
    if modem_count.zero?
      5.times do |index|
        modem = Faker::Bank.name
        new_id = id[index]
        hash = { id: new_id, name: modem }
        bank << hash
        modem_array << [modem.to_s]
        date_range.times do
          modem_array.at(index) << rand(600)
        end
      end
    else
      modem_params_array.each_with_index do |modem, index|
        new_id = id[index]
        bank << { id: new_id, name: modem }
        modem_array << [modem]
        date_range.times do
          modem_array.at(index) << rand(600)
        end
      end
    end

    # ##single-select-2###

    languange = []
    id = (1..5).to_a
    if modem_count.zero?
      5.times do |index|
        modem = Faker::Address.city
        new_id = id[index]
        hash = { id: new_id, name: modem }
        languange << hash
        modem_array << [modem.to_s]
        date_range.times do
          modem_array.at(index) << rand(600)
        end
      end
    else
      modem_params_array.each_with_index do |modem, index|
        new_id = id[index]
        languange << { id: new_id, name: modem }
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
        type: 'date-picker'
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
      {
        dataset:
        [
          { available_collection: bank, param_name: 'banks' }
        ],
        type: 'single-select',
        title: 'bank'
      },
      {
        dataset:
        [
          { available_collection: languange, param_name: 'languanges' }
        ],
        type: 'single-select',
        title: 'languanges'
      }
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
    render json: @charts.widget[:data].to_json
  end

  def timeseries
    params = JSON.parse(request.body.read)
    array = []
    array << ['x', '2013-01-01', '2013-01-02', '2013-01-03', '2013-01-04', '2013-01-05', '2013-01-06']
    array << ['data1', 30, 200, 100, 400, 150, 250]
    array << ['data2', 130, 340, 200, 500, 250, 350]

    result = filters(params)

    result = {
      columns: array,
      xFormat: '%Y-%m-5d %H:%M',
      filters: result[:filters]

    }
    @charts = WidgeCharts.new(
      WidgeChart.new(result).to_h
    )
    render json: @charts.widget[:data].to_json
  end

  def bar
    params = JSON.parse(request.body.read)
    result = filters(params)
    result = {
      columns: [
        ['data1', 30, 200, 100, 400, 150, 250],
        ['data2', 130, 100, 140, 200, 150, 50]
      ],
      type: 'bar',
      filters: result[:filters]
    }
    @charts = WidgeCharts.new(
      WidgeChart.new(result).to_h
    )
    render json: @charts.widget[:data].to_json
  end

  def pie
    params = JSON.parse(request.body.read)
    result = filters(params)

    result = {
      columns: [
        ['data1', 30],
        ['data2', 120]
      ],
      filters: result[:filters],
      type: 'pie'
    }

    @charts = WidgeCharts.new(
      WidgeChart.new(result).to_h
    )
    render json: @charts.widget[:data].to_json
  end

  def unauthorized
    render json: { message: 'Unauthorized!' }, status: 401
  end

  def unprocessable
    render json:  { message: 'Unprocessable entity!' }, status: 422
  end

  def server_error
    render json:  { message: 'Server Error!' }, status: 500
  end

  def origin_error
    render json:  { message: 'Origin Error!' }, status: 520
  end
end
