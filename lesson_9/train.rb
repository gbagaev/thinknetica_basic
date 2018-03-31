require_relative 'company_name'
require_relative 'instance_counter'
require_relative 'validation'

class Train
  include CompanyName
  include InstanceCounter
  include Validation

  attr_reader :type, :wagons, :route, :speed, :number

  validate :number, :format, with: /^[a-z0-9]{3}-*[a-z0-9]{2}$/

  @@all = {}

  def self.all
    @@all
  end

  def self.find(number)
    all[number]
  end

  def initialize(number)
    @number = number
    @wagons = []
    stop
    validate!
    self.class.all[number] = self
  end

  def yield_wagons
    wagons.each { |wagon| yield(wagon) } if block_given?
  end

  def speed_up(value)
    if @speed + value < 0
      stop
    else
      @speed += value
    end
  end

  def speed_down(value)
    if @speed - value < 0
      stop
    else
      @speed -= value
    end
  end

  def add_wagon(wagon)
    return unless stopped? && wagon.is_a?(Wagon) && !wagons.include?(wagon)
    wagon.number = wagons.empty? ? 1 : wagons.last.number + 1
    @wagons << wagon
  end

  def remove_wagon(wagon)
    @wagons.delete(wagon) if stopped?
  end

  def route=(route)
    @route = route
    @current_station_index = 0
    current_station.receive_train(self)
  end

  def go_forward
    return unless current_station && next_station
    current_station.send_train(self)
    @current_station_index += 1
    current_station.receive_train(self)
    current_station
  end

  def go_back
    return unless current_station && previous_station
    current_station.send_train(self)
    @current_station_index -= 1
    current_station.receive_train(self)
    current_station
  end

  private

  def stop
    @speed = 0
  end

  def stopped?
    @speed.zero?
  end

  def current_station
    route.stations[@current_station_index] if route
  end

  def previous_station
    return unless route && @current_station_index > 0
    route.stations[@current_station_index - 1]
  end

  def next_station
    route.stations[@current_station_index + 1]
  end
end
