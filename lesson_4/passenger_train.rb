#require_relative 'route'
#require_relative 'train'
#require_relative 'station'
#require_relative 'cargo_train'
#require_relative 'cargo_wagon'
#require_relative 'passenger_wagon'

class PassengerTrain < Train

  def add_wagon(wagon)
    super if wagon.class == PassengerWagon
  end

  def remove_wagon(wagon)
    super
  end
end
