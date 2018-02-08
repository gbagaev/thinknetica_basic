require_relative 'company_name'
require_relative 'instance_counter'

class Train
  include CompanyName
  include InstanceCounter

  attr_reader :type, :wagons, :route, :speed, :number

  NUMBER_FORMAT = /^[a-z0-9]{3}-*[a-z0-9]{2}$/

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

  def valid?
    validate!
  rescue
    false
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
    @wagons << wagon if stopped? && wagon.is_a?(Wagon)
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
    if current_station && next_station
      current_station.send_train(self)
      @current_station_index += 1
      current_station.receive_train(self)
      current_station
    end
  end

  def go_back
    if current_station && previous_station
      current_station.send_train(self)
      @current_station_index -= 1
      current_station.receive_train(self)
      current_station
    end
  end

  private

  def validate!
    raise 'Number has invalid format!' if number !~ NUMBER_FORMAT
    true
  end

  def stop
    @speed = 0
  end

  def stopped?
    @speed == 0
  end

  def current_station
    route.stations[@current_station_index] if route
  end

  def previous_station
    if route && @current_station_index > 0
      route.stations[@current_station_index - 1]
    end
  end

  def next_station
    route.stations[@current_station_index + 1]
  end
end
