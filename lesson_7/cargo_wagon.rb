class CargoWagon < Wagon

  def initialize(all_place)
    @type = 'cargo'
    super(all_place)
  end
end
