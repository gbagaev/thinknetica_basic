require_relative 'company_name'
require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

class Wagon
  include CompanyName
  include InstanceCounter
  include Validation
  extend Accessors

  attr_accessor_with_history :number
  attr_reader :all_place, :free_place

  validate :all_place, :type, type: Numeric

  def initialize(amount, type)
    @all_place = amount
    @type = type
    @free_place = amount
    validate!
    register_instance
  end

  def use_place(amount)
    if amount.is_a?(Numeric) && amount > 0 && amount <= free_place
      @free_place -= amount
    else
      puts 'You type incorrect amount!'
    end
  end

  def used_place
    all_place - free_place
  end

  private

  def validate!
    super
    return true if all_place > 0
    raise "Amount must be Numeric greater then 0. #{all_place.inspect} passed"
  end
end
