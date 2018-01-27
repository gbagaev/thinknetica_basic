class Route
  attr_reader :stations

  def initialize(first, last)
    @stations = [first, last]
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def remove_station(station)
    stations.delete(station)
  end

  def to_s
    stations_string = stations.map { |station| station.name }.join(', ')
    "Route: #{stations_string}"
  end
end
