class Route
  attr_reader :stations

  def initialize(first, last)
    @stations = [first, last]
    validate!
  end

  def valid?
    validate!
  rescue
    false
  end

  def add_station(station)
    return unless station
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

  def validate!
    raise 'You route has invalid stations!' unless stations.first.is_a?(Station) && stations.last.is_a?(Station)
    true
  end
end
