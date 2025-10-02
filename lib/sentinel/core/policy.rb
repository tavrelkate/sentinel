# frozen_string_literal: true

require 'forwardable'

module Sentinel
  class Policy
    def self.describe(name, &block)
      builder_class = Class.new do
        attr_accessor :keywords, :regexes, :label

        def initialize
          @keywords = []
          @regexes  = []
          @label    = nil
        end

        def keywords(*list) = @keywords.concat(list.flatten)
        def regexes(*list)  = @regexes.concat(list.flatten)
        def label(text = nil) = @label = text
        alias_method :description, :label
      end

      builder = builder_class.new
      builder.instance_eval(&block) if block

      new(
        name: name,
        keywords: builder.keywords,
        regexes: builder.regexes,
        label: builder.label
      ).tap { register_it(_1) }
    end

    def self.registry
      @registry ||= {}
    end

    def self.all
      registry.dup.freeze
    end

    def self.register_it(it)
      registry[it.name] = it
    end

    attr_reader :name, :keywords, :regexes, :label

    def initialize(name:, keywords:, regexes:, label:)
      unless [Symbol, String].include?(name.class)
        raise argument_error(:name, name)
      end

      unless [Array, Set].include?(keywords.class)
        raise argument_error(:keywords, keywords)
      end

      unless [Array, Set].include?(regexes.class)
        raise argument_error(:regexes, regexes)
      end

      unless [NilClass, Symbol, String].include?(label.class)
        raise argument_error(:label, label)
      end

      @keywords = Array(keywords).flatten.flat_map do |kw|
        kw.to_s if kw.is_a?(String) || kw.is_a?(Symbol)
      end.compact.uniq.freeze

      @regexes = Array(regexes).flatten.flat_map do |r|
        r if r.is_a?(Regexp)
      end.compact.uniq.freeze

      @name = name.to_sym

      @label = label&.to_s
    end

    def to_h
      { name: name, keywords: keywords, regexes: regexes, label: label }
    end

    def inspect
      "#<#{self.class} name=#{name.inspect} label=#{label.inspect} keywords=#{keywords.size} regexes=#{regexes.size}>"
    end

    def argument_error(arg_type, value)
      ArgumentError.new("invalid #{arg_type}: #{value.inspect}")
    end
  end
end
