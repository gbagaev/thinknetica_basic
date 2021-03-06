class Station
  attr_reader :name, :trains

  @@all = []

  def self.all
    @@all
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    self.class.all << self
  end

  def yield_trains
    trains.each { |train| yield(train) } if block_given?
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  def receive_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type }
  end

  protected

  def validate!
    raise 'You name has invalid format!' if name !~ /^[a-z]{1,8}-*\d{,2}$/i
  end
end
