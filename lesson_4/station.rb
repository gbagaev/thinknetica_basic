#require_relative 'route'
#require_relative 'train'
#require_relative 'passenger_train'
#equire_relative 'cargo_train'
#require_relative 'cargo_wagon'
#require_relative 'passenger_wagon'

class Station < Train
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
