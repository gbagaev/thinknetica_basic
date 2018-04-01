module Validation
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    VALIDATIONS = {
        presence: {},
        format: {
            required_opts: { with: Regexp },
            err_msg: 'validation of format requires format regexp passed by :with option'
        },
        type: {
            required_opts: { type: Class },
            err_msg: 'validation of type requires :type option. :type should be a Class'
        }
    }.freeze

    VALIDATION_TYPES = VALIDATIONS.keys.freeze

    def validate(attribute, validation_type, options = {})
      if VALIDATION_TYPES.include?(validation_type) && validated_correctly?(validation_type, options)
        @validations ||= {}
        @validations[validation_type] ||= {}
        @validations[validation_type][attribute] = options
      else
        raise ArgumentError, "validation of #{validation_type} is not implemented"
      end
    end

    private

    def validated_correctly?(validation_type, options)
      validation_data = VALIDATIONS[validation_type]
      validation_data[:required_opts].all? do |option, value|
        next true if options[option].is_a?(value)
        raise ArgumentError, validation_data[:err_msg]
      end
    end

    def validate_presence(attribute, value, _options)
      raise ArgumentError, "#{attribute} is required!" if value.nil?
    end

    def validate_format(attribute, value, options)
      error = options[:error] || 'has invalid format'
      raise ArgumentError, "#{attribute} #{error}" unless value =~ options[:with]
    end

    def validate_type(attribute, value, options)
      attr_type = options[:type]
      error = options[:error] || "should be kind of #{attr_type}"
      raise ArgumentError, "#{attribute} #{error}" unless value.is_a?(attr_type)
    end
  end

  def validate!
    @errors = {}
    validations = self.class.instance_variable_get(:@validations)
    validations.each do |validation_type, attributes|
      attributes.each do |attribute, options|
        begin
          self.class.send("validate_#{validation_type}", attribute, instance_variable_get("@#{attribute}"), options)
        rescue ArgumentError => e
          @errors[attribute] ||= []
          @errors[attribute] << e
        end
      end
    end
    unless @errors.empty?
      error_message = @errors.map { |attribute, attr_errors| "#{attribute}: #{attr_errors.join(', ')}" }.join(";\n")
      raise ArgumentError, error_message
    end
  end

  def valid?
    validate!
    true
  rescue ArgumentError
    false
  end
end
