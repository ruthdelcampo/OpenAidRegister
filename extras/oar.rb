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

  def self.match_email(email)
    String format_email = (/^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i)
    email.match(format_email)
  end

  def self.quote(str)
    str.gsub("\\","\\\\\\\\").gsub("'","\\\\'")
  end

  def self.quote_string(v)
    v.to_s.gsub(/\\/, '\&\&').gsub(/'/, "''")
  end

  def self.uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  end


end
