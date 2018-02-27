class PassengerWagon < Wagon
  attr_reader :all_seats, :vacant_seats

  def initialize(all_seats)
    @type = 'passenger'
    @all_seats = all_seats
    @vacant_seats = all_seats
    validate!
    super
  end

  def take_a_seat
    @vacant_seats -= 1 if vacant_seats > 0
  end

  def busy_seats
    all_seats - vacant_seats
  end

  private

  def validate!
    return true if all_seats.is_a?(Integer) && all_seats > 0
    raise "all_seats must be an Integer greater then 0. #{all_seats.inspect} passed"
  end
end