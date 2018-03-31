module Accessors
  def attr_accessor_with_history(*attrbiutes)
    attributes.each do |attribute|
      attr_instance_var = "@#{attribute}".to_sym
      history_attr = "#{attribute}_history".to_sym
      history_instance_var = "@{history_attr}".to_sym

      define_method(attribute) { instance_variable_get(attr_instance_var) }
      define_method(history_attr) { instance_variable_get(history_instance_var) || [] }

      define_method("#{attribute}=".to_sym) do |value|
        instance_variable_set(attr_instance_var, value)
        old_history = public_send(history_attr)
        instance_variable_set(history_instance_var, (old_history << value))
      end
    end
  end

  def strong_attr_accessor(attribute, klass)
    define_method(attribute) { instance_variable_get("@#{attribute}") }
    define_method("#{attribute}=") do |value|
      if value.is_a?(klass)
        instance_variable_set("@#{attribute}", value)
      else
        raise ArgumentError, "#{value} is a #{value.class}. Expected #{klass}"
      end
    end
  end
end
