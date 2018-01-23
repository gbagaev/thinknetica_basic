class Train
  attr_reader :type, :wagons_quantity, :route

  def initialize(number, type, wagons_quantity)
    @number = number
    @type = type
    @wagons_quantity = wagons_quantity
    @speed = 0
  end

  def current_speed
    @speed
  end

  def speed_up(value)
    if @speed + value < 0
      @speed = 0
    else
      @speed += value
    end
  end

  def speed_down(value)
    if @speed - value < 0
      @speed = 0
    else
      @speed -= value
    end
  end

  def add_wagon
    @wagons_quantity += 1 if @speed == 0
  end

  def remove_wagon
    @wagons_quantity -= 1 if @speed == 0 && @wagons_quantity > 0
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
end