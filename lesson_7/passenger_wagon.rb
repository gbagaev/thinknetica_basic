class PassengerWagon < Wagon

  def initialize(all_place)
    @type = 'passenger'
    super(all_place)
  end

  def use_place
    super(1)
  end
end
