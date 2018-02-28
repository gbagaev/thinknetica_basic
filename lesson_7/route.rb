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
  rescue
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
    stations_string = stations.map { |station| station.name }.join(', ')
    "Route: #{stations_string}"
  end

  protected

  def validate_station!(station)
    raise "#{station.inspect} is not an instance of Station" unless station.is_a?(Station)
    true
  end
end
