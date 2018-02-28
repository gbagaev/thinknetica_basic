class PassengerTrain < Train
  def initialize(number) # 5
    @type = 'passenger'
    super
  end

  def add_wagon(wagon)
    super if wagon.is_a?(PassengerWagon)
  end
end
