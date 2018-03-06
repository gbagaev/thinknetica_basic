class PassengerWagon < Wagon
  def initialize(all_place)
    super(all_place, 'passenger')
  end

  def use_place
    super(1)
  end
end
