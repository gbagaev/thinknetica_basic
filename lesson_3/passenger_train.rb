require_relative 'route'
require_relative 'train'
require_relative 'station'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class PassengerTrain < Train
  attr_reader :wagons

  def add_wagon(passenger_wagon)
    wagons << passenger_wagon if stop
  end

  def remove_wagon(passenger_wagon)
    wagons.delete(passenger_wagon) if stop
  end
end
