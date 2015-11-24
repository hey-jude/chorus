class ChiasmApiDatasetsController < ApplicationController
  include Authorization::DataSourceAuth

  # Returns the column metadata in this form:
  # [{ 'name': 'age',          'type': 'number'},
  #  { 'name': 'capital_gain', 'type': 'number'},
  #  { 'name': 'capital_loss', 'type': 'number'}]
  def show_column_data
    dataset = Dataset.find(params[:dataset_id])

    column_types_map = [

        # Numeric types based on this list http://www.postgresql.org/docs/9.1/static/datatype-numeric.html
        {:chorus_type => /integer/, :chiasm_type => 'number'},
        {:chorus_type => /double/, :chiasm_type => 'number'},
        {:chorus_type => /smallint/, :chiasm_type => 'number'},
        {:chorus_type => /bigint/, :chiasm_type => 'number'},
        {:chorus_type => /decimal/, :chiasm_type => 'number'},
        {:chorus_type => /numeric/, :chiasm_type => 'number'},
        {:chorus_type => /real/, :chiasm_type => 'number'},
        {:chorus_type => /serial/, :chiasm_type => 'number'},
        {:chorus_type => /bigserial/, :chiasm_type => 'number'},

        {:chorus_type => /varying/, :chiasm_type => 'string'}
    ]

    column_data = dataset.column_data.sort_by { |col| col.name }.collect { |col|
      convert_chorus_to_chiasm_type = column_types_map.find { |h| h[:chorus_type].match col.data_type }

      if convert_chorus_to_chiasm_type
        chiasm_type = convert_chorus_to_chiasm_type[:chiasm_type]
      else
        chiasm_type = "string"
      end

      {name: col.name, type: chiasm_type}
    }

    render :json => column_data
  end

  # Returns the data itself, in CSV form:
  # sepal_length,sepal_width,petal_length,petal_width,class
  # 5.1,3.5,1.4,0.2,setosa
  # 4.9,3.0,1.4,0.2,setosa
  def show_data
    dataset = Dataset.find(params[:dataset_id])
    numRows = params[:numRows]

    # TODO Curran / Mike Souza: pass 'check_id' in from Backbone ...
    check_id = rand(0..1000000)

    @connection = dataset.connect_with(authorized_account(dataset))
    @sql_generator = @connection.visualization_sql_generator

    # TODO Curran / Michael Thyen -- passing in :foo so we have the option to pass multiple named options,
    # otherwise we can clean it up (just pass dataset)
    row_sql = @sql_generator.random_sampling_sql(:dataset => dataset, :numRows => numRows)

    # TODO Curran / Mike Souza see VisLegacy -> VisualizationsController#destroy -- the query must be cancellable for
    # a reason, we will probably need to wire up something equivalent, passing the 'check_id' along
    # as a key for the cancelling of query.
    result = CancelableQuery.new(@connection, check_id, current_user).execute(row_sql)
    rows = result.rows

    csv = CSV.generate(headers: true, force_quotes: true) do |csv|
      csv << dataset.column_names.sort
      rows.each do |row|
        csv << row
      end
    end

    render :text => csv
  end

end
