require_relative 'accessors'

module CompanyName
  extend Accessors

  attr_accessor_with_history :company_name
end
