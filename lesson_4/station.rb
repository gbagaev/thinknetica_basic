class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def receive_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def train_list_by_type(type)
    trains.count { |train| train.type == type }
  end
end