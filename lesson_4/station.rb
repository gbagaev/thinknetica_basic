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

  def valid?
    validate!
  rescue
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
    raise 'You name has invalid format!' if /^[a-z]
  end
end
