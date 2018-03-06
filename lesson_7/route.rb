require_relative 'station'

class Route
  attr_reader :stations

  def initialize(first, last)
    validate_station!(first)
    validate_station!(last)
    @stations = [first, last]
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  def add_station(station)
    validate_station!(station)
    if stations.include?(station)
      puts 'Route already has this station!'
    else
      stations.insert(-2, station)
    end
  end

  def remove_station(station)
    stations.delete(station)
  end

  def to_s
    stations_string = stations.map(&:name).join(', ')
    "Route: #{stations_string}"
  end

  protected

  def validate_station!(station)
    return true if station.is_a?(Station)
    raise "#{station.inspect} is not an instance of Station"
  end
end
