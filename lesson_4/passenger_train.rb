class PassengerTrain < Train
  def add_wagon(wagon)
    super if wagon.is_a?(PassengerWagon)
  end
end
