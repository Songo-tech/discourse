# frozen_string_literal: true

module Migrations::Importer
  class DiscourseDB
    COPY_BATCH_SIZE = 1_000

    def initialize
      @encoder = PG::TextEncoder::CopyRow.new
      @connection = PG::Connection.new(database_configuration)
      @connection.type_map_for_results = PG::BasicTypeMapForResults.new(@connection)
    end

    def copy_data(table_name, column_names, rows)
      quoted_column_name_list = column_names.map { |c| quote_identifier(c) }.join(",")
      sql = "COPY #{table_name} (#{quoted_column_name_list}) FROM STDIN"

      # FIXME Move transaction around `copy_data` call ... this is just for testing
      @connection.transaction do
        rows.each_slice(COPY_BATCH_SIZE) do |sliced_rows|
          # TODO Maybe add error handling and check if all rows fail to insert, or only
          # some of them fail. Currently, if a single row fails to insert, then an exception
          # will stop the whole import. Which seems fine because ideally the import script
          # should ensure all data is valid. We might need to see how this works out in
          # actual migrations...
          @connection.copy_data(sql, @encoder) do
            sliced_rows.each do |row|
              data = column_names.map { |c| row[c] }
              @connection.put_copy_data(data)
            end
          end

          # give the caller a chance to do some work when a batch has been committed,
          # for example, to store ID mappings
          yield sliced_rows
        end

        raise PG::RollbackTransaction
      end

      nil
    end

    def last_id_of(table_name)
      query = <<~SQL
        SELECT COALESCE(MAX(id), 0)
          FROM #{quote_identifier(table_name)}
      SQL

      result = @connection.exec(query)
      result.getvalue(0, 0)
    end

    def fix_last_id_of(table_name)
      table_name = quote_identifier(table_name)
      query = <<~SQL
        SELECT SETVAL(PG_GET_SERIAL_SEQUENCE('#{table_name}', 'id'), MAX(id))
          FROM #{table_name}
        HAVING MAX(id) > 0
      SQL

      @connection.exec(query)
      nil
    end

    def column_names(table_name)
      query = <<~SQL
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = $1
        ORDER BY ordinal_position
      SQL

      result = @connection.exec_params(query, [table_name])
      result.column_values(0).map(&:to_sym)
    end

    def close
      @connection.finish
    end

    private

    def database_configuration
      db_config = ActiveRecord::Base.connection_db_config.configuration_hash

      # credentials for PostgreSQL in CI environment
      if Rails.env.test?
        username = ENV["PGUSER"]
        password = ENV["PGPASSWORD"]
      end

      {
        host: db_config[:host],
        port: db_config[:port],
        username: db_config[:username] || username,
        password: db_config[:password] || password,
        dbname: db_config[:database],
      }.compact
    end

    def quote_identifier(identifier)
      PG::Connection.quote_ident(identifier.to_s)
    end
  end
end
