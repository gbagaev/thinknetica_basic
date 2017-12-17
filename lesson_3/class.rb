class Train
  attr_reader :type, :wagons_quantity, :route, :speed

  def initialize(number, type, wagons_quantity)
    @number = number
    @type = type
    @wagons_quantity = wagons_quantity
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

  #def speed_down(value)
   # if speed - value > 0 && speed - value <= speed
    #  self.speed -= value
    #else
     # stop
    #end
  #end

  def speed_down(value)
    if speed - value.abs < 0
      stop
    else
      self.speed -= value.abs
    end
  end

  def add_wagon
    @wagons_quantity += 1 if stop
  end

  def remove_wagon
    @wagons_quantity -= 1 if stop # && @wagons_quantity > 0
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

  attr_writer :speed # чтобы субъект не мог напрямую поменять скорость

  def stop
    self.speed = 0
  end
end
