class CargoWagon < Wagon
  attr_reader :volume, :free_volume

  def initialize(volume)
    @type = 'cargo'
    @volume = volume
    @free_volume = volume
    validate!
    super
  end

  def use_volume(amount)
    if amount.is_a?(Numeric) && amount > 0 && amount <= free_volume
      @free_volume -= amount
    else
      puts 'You type incorrect amount!'
    end
  end

  def used_volume
    volume - free_volume
  end

  private

  def validate!
    return true if volume.is_a?(Numeric) && volume > 0
    raise "volume must be Numeric greater then 0. #{volume.inspect} passed"
  end
end