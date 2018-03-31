# module Validation
#   def self.included(base)
#     base.extend(ClassMethods)
#   end
#
#   module ClassMethods
#     VALIDATION_TYPES = [:presence, :format, :type]
#
#     def validate(attribute, validation_type, options = {})
#       if VALIDATION_TYPES.include?(validation_type)
#         @validations ||= {}
#         @validations[validation_type] ||= {}
#         @validations[validation_type][attribute] = options
#       else
#         raise ArgumentError, "validation of #{validation_type} is not implemented"
#       end
#     end
#
#     def validate_presence(attribute, value, _options)
#       raise ArgumentError, "#{attribute} is required!" if value.nil?
#     end
#
#     def validate_format(attribute, value, options)
#       regexp = options[:with]
#       raise ArgumentError, 'validation of format requires format regexp passed by :with option - `validate :attr, :format, with: /.../`' unless regexp.is_a?(Regexp)
#
#       error = options[:error] || 'has invalid format'
#       raise ArgumentError, "#{attribute} #{error}" unless value =~ options[:with]
#     end
#
#     def validate_type(attribute, value, options)
#       attr_type = options[:type]
#       raise ArgumentError, 'validation of type requires :type option - `validate :attr, :type, type: String`' unless attr_type.is_a?(Class)
#
#       error = options[:error] || "should be kind of #{attr_type}"
#       raise ArgumentError, "#{attribute} #{error}" unless value.is_a?(attr_type)
#     end
#   end
#
#   def validate!
#     @errors = {}
#     validations = self.class.instance_variable_get(:@validations)
#     validations.each do |validation_type, attributes|
#       attributes.each do |attribute, options|
#         begin
#           self.class.public_send("validate_#{validation_type}", attribute, public_send(attribute), options)
#         rescue ArgumentError => e
#           @errors[attribute] ||= []
#           @errors[attribute] << e
#         end
#       end
#     end
#     return true if @errors.empty?
#
#     error_message = @errors.map { |attribute, attr_errors| "#{attribute}: #{attr_errors.join(', ')}" }.join(";\n")
#     @errors.empty? ? true : raise(ArgumentError, error_message)
#   end
#
#   def valid?
#     validate!
#   rescue ArgumentError
#     false
#   end
# end
#
# class Person
#   include Validation
#
#   attr_reader :name, :last_name
#
#   validate :name, :presence
#   validate :last_name, :presence
#   validate :name, :type, type: String
#   validate :last_name, :type
#   validate :name, :format, with: /\w+/, error: 'can contain letters only'
#
#
#   def initialize(name, last_name)
#     @name = name
#     @last_name = last_name
#   end
# end

module Validation
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    VALIDATION_TYPES = [:presence, :format, :type]

    def validate(attribute, validation_type, options = {})
      puts "attribute: #{attribute}"
      puts "validation_type: #{validation_type}"

      if VALIDATION_TYPES.include?(validation_type)
        @validations ||= {}
        puts 1
        puts @validations.inspect
        @validations[validation_type] ||= {}
        puts 2
        puts @validations.inspect
        @validations[validation_type][attribute] = options
        puts 3
        puts @validations.inspect
      else
        raise ArgumentError, "validation of #{validation_type} is not implemented"
      end
      puts '=========================================='
    end

    def validate_presence(attribute, value, _options)
      raise ArgumentError, "#{attribute} is required!" if value.nil?
    end

    def validate_format(attribute, value, options)
      regexp = options[:with]
      raise ArgumentError, 'validation of format requires format regexp passed by :with option - `validate :attr, :format, with: /.../`' unless regexp.is_a?(Regexp)

      error = options[:error] || 'has invalid format'
      raise ArgumentError, "#{attribute} #{error}" unless value =~ lidateoptions[:with]
    end

    def validate_type(attribute, value, options)
      attr_type = options[:type]
      raise ArgumentError, 'validation of type requires :type option - `validate :attr, :type, type: String`' unless attr_type.is_a?(Class)

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
          self.class.public_send("validate_#{validation_type}", attribute, public_send(attribute), options)
        rescue ArgumentError => e
          @errors[attribute] ||= []
          @errors[attribute] << e
        end
      end
    end
    return true if @errors.empty?

    error_message = @errors.map { |attribute, attr_errors| "#{attribute}: #{attr_errors.join(', ')}" }.join(";\n")
    @errors.empty? ? true : raise(ArgumentError, error_message)
  end

  def valid?
    validate!
  rescue ArgumentError
    false
  end
end

class Person
  include Validation

  attr_reader :name, :last_name

  validate :name, :presence
  validate :last_name, :presence
  validate :name, :type, type: String
  validate :last_name, :type
  validate :name, :format, with: /\w+/, error: 'can contain letters only'


  def initialize(name, last_name)
    @name = name
    @last_name = last_name
  end
end
