module ApplicationHelper

  def format_date(date)
    return date.strftime('%m/%d/%Y') if date.present? && date.is_a?(Date)
    date
  end

  def format_date_dash(date)
    return date.strftime('%Y-%m-%d') if date.present? && date.is_a?(Date)
    date
  end

  def collaboration_type_by_id(id)
    COLLABORATION_TYPE_LIST.select{|collaboration_type| collaboration_type.last.to_i == id.to_i}.first.first if id.present?
  end

  def collaboration_type_by_name(name)
    COLLABORATION_TYPE_LIST.select{|collaboration_type| collaboration_type.first == name}.first.last if name.present?
  end

  def aid_type_by_id(id)
    AID_TYPE_LIST.select{|aid_type| aid_type.last == id}.first.first if id.present?
  end

  def aid_type_by_name(name)
    AID_TYPE_LIST.select{|aid_type| aid_type.first == name}.first.last if name.present?
  end

  def tied_status_by_id(id)
    TIED_STATUS_LIST.select{|tied_status| tied_status.last.to_i == id.to_i}.first.first if id.present?
  end

  def tied_status_by_name(name)
    TIED_STATUS_LIST.select{|tied_status| tied_status.first == name}.first.last if name.present?
  end

  def flow_type_by_id(id)
    FLOW_TYPE_LIST.select{|flow_type| flow_type.last.to_i == id.to_i}.first.first if id.present?
  end

  def flow_type_by_name(name)
    FLOW_TYPE_LIST.select{|flow_type| flow_type.first == name}.first.last if name.present?
  end


  def finance_type_by_id(id)
    FINANCE_TYPE_LIST.select{|finance_type| finance_type.last.to_i == id.to_i}.first.first if id.present?
  end

  def finance_type_by_name(name)
    FINANCE_TYPE_LIST.select{|finance_type| finance_type.first == name}.first.last if name.present?
  end

  def transaction_type_by_id(id)
    TRANSACTION_TYPE_LIST.select{|transaction_type| transaction_type.last == id}.first.first if id.present?
  end

  def transaction_type_by_name(name)
    TRANSACTION_TYPE_LIST.select{|transaction_type| transaction_type.first == name}.first.last if name.present?
  end

  def currency_by_id(id)
    CURRENCY_LIST.select{|currency| currency.last == id}.first.first if id.present?
  end

  def currency_by_name(name)
    CURRENCY_LIST.select{|currency| currency.first == name}.first.last if name.present?
  end

  def country_by_id(id)
    COUNTRY_LIST.select{|country| country.last == id}.first.first if id.present?
  end

  def country_by_name(name)
    COUNTRY_LIST.select{|country| country.first == name}.first.last if name.present?
  end

  def sector_by_id(id)
    SECTORS_LIST.select{|sector| sector.last.to_i == id.to_i}.first.first if id.present?
  end

end
