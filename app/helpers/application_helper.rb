module ApplicationHelper
  def format_date(date)
    date.strftime('%m/%d/%Y') if date
  end
end
