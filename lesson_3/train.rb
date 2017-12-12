require_relative 'route'
require_relative 'station'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class Train
  attr_reader :type, :route, :speed

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
  end

  def speed_up(value)
    if speed + value < 0
      stop
    else
      self.speed += value
    end
  end

  def speed_down(value)
    if speed - value.abs < 0
      stop
    else
      self.speed -= value.abs
    end
  end

  def add_wagon(passenger_wagon)
    wagons << passenger_wagon if stop && PassengerWagon.new
  end

  def remove_wagon(passenger_wagon)
    wagons.delete(passenger_wagon) if stop # && @wagons_quantity > 0
  end

  def route=(route)
    @route = route
    @current_station_index = 0
    current_station.receive_train(self)
  end

  def current_station
    route.stations[@current_station_index]
  end

  def previous_station
    if @current_station_index > 0
      route.stations[@current_station_index - 1]
    end
  end

  def next_station
    route.stations[@current_station_index + 1]
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

  attr_writer :speed

  def stop
    self.speed = 0
  end
end
