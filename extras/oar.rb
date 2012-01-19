module Oar
  def self.execute_query(sql, *params)
    prepared_statement = sql.gsub(/\?/) do |match|
      param = params.shift
      case param
      when Date
        "'#{param.to_s}'"
      else
        param.to_s.sanitize_sql!
      end
    end
    CartoDB::Connection.query(prepared_statement)
  end

  def self.is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
end
