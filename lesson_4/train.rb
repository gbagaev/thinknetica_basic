class Train
  attr_reader :type, :wagons, :route

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
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

  def add_wagon(wagon)
    @wagons << wagon if @speed == 0 && wagon.is_a?(Wagon)
  end

  def remove_wagon(wagon)
    @wagons.delete(wagon) if @speed == 0
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