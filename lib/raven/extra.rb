require 'raven'
require 'active_support/core_ext/module/aliasing'

class Exception
  attr_accessor :extra, :level

  def with_extra(extra)
    self.extra ||= {}
    self.extra.deep_merge!(extra)
    self
  end

  def with_level(level)
    self.level = level
    self
  end
end

class Object
  def decorating_exceptions_with(extra, level=nil)
    yield
  rescue Exception => e
    if level
      raise e.with_extra(extra).with_level(level)
    else
      raise e.with_extra(extra)
    end
  end
end

module Raven
  class << self
    def tags_context_with_string_keys(options = nil)
      tags_context_without_string_keys(options.try(:stringify_keys))
    end

    def extra_context_with_string_keys(options = nil)
      extra_context_without_string_keys(options.try(:stringify_keys))
    end

    def capture_message_with_level(message, options={})
      capture_message_without_level(message, options.reverse_merge(:level => :info))
    end

    alias_method_chain :tags_context, :string_keys
    alias_method_chain :extra_context, :string_keys
    alias_method_chain :capture_message, :level
  end

  class Event
    def parse_exception_with_extra(exception)
      parse_exception_without_extra(exception)

      if exception.respond_to?(:extra) && extra = exception.extra
        self.extra ||= {}
        self.extra.deep_merge!(extra)
      end
    end

    def parse_exception_with_level(exception)
      parse_exception_without_level(exception)

      if exception.respond_to?(:level) && level = exception.level
        self.level = level
      end
    end

    alias_method_chain :parse_exception, :extra
    alias_method_chain :parse_exception, :level
  end
end
