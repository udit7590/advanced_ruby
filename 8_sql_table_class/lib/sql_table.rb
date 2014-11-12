class SQLTable
  
  def create_table(table_name, &block)
    @query = "CREATE TABLE #{ table_name } ("
    yield self
    @query.chop!
    @query << ');'
    p @query
  end

  # ------------------------------------------------------------------------
  # SECTION FOR DEFINING DATA TYPE METHODS
  # ------------------------------------------------------------------------

  def boolean(column_name, options = {})
    @query << "#{ column_name } BIT(1) "
    define_options(options, 'boolean')
    @query << ','
  end

  def string(column_name, options = {})
    raise "Please define length for field #{ column_name }" if options[:length].nil?
    @query << "#{ column_name } VARCHAR(#{ options[:length] }) "
    define_options(options, 'string')
    @query << ','
  end

  def number(column_name, options = {})
    @query << "#{ column_name } INT "
    define_options(options, 'int')
    @query << ','
  end

  def datetime(column_name, options = {})
    @query << "#{ column_name } DATETIME "
    define_options(options, 'datetime')
    @query << ','
  end

  # ------------------------------------------------------------------------
  # SECTION FOR UTILITY METHODS
  # ------------------------------------------------------------------------

  private

  def define_options(options, type = 'none')
    options.each_pair do |key, value|
      case key.to_s
      when 'default'
        @query << default_value(value, type)
      when 'null'
        @query << is_null(value)
      end
    end
  end

  def default_value(value, type = 'none')
    case type
    when 'string'
      "DEFAULT '#{value}' "
    when 'boolean'
      (value ? "DEFAULT 1 " : "DEFAULT 0 ")
    when 'datetime'
      value.nil? ? 'DEFAULT NULL' : "DEFAULT '#{value}' "
    else
      "DEFAULT #{value} "
    end
  end

  def is_null(value)
    (value ? "NOT NULL " : "")
  end

end
