class Station
  attr_reader :station_name, :trains

  def initialize(station_name)
    @station_name = station_name
    @trains = []
  end

  def receive_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete train
  end

  def train_list_by_type(type)
    trains.count { |train| train.type == type }
  end
end


class Route
  attr_reader :first, :last, :stations

  def initialize(first, last)
    @stations = [first, last]
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def remove_station(station)
    stations.delete station
  end

  def first_station
    stations.first
  end

  def last_station
    stations.last
  end

  def route=(route)
    @route = route
    @current_station_index = 0
  end
end


class Train
  attr_reader :type, :wagons_quantity, :route

  def initialize(number, type, wagons_quantity)
    @number = number
    @type = type
    @wagons_quantity = wagons_quantity
    @speed = 0
  end

  def speed_up(value)
    @speed += value
  end

  def speed_down(value)
    @speed -= value
  end

  def add_wagon
    @wagons_quantity += 1 if speed == 0
  end

  def remove_wagon
    @wagons_quantity -= 1 if speed == 0
  end

  def route=(route)
    @route = route
    @current_station_index = 0
  end

  def current_station
    route.stations[@current_station_index]
  end

  def previous_station
    route.stations[@current_station_index - 1]
  end

  def next_station
    route.stations[@current_station_index + 1]
  end

  def go_forward
    if current_station && next_station
      @current_station_index += 1
      route.stations[@current_station_index]
    end
  end

  def go_back
    if current_station && previous_station
      @current_station_index -= 1
      route.stations[@current_station_index]
    end
  end
end
