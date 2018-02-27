require_relative 'company_name'
require_relative 'instance_counter'

class Wagon
  include CompanyName
  include InstanceCounter

  attr_accessor :number
  attr_reader :type

  def initialize(*)
    register_instance
  end
end
