module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def instances
      @instances ||= 0
    end

    def instances=(value)
      @instances = value
    end
  end

  protected

  def register_instance
    self.class.instances += 1
  end
end
