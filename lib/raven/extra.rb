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
    raise e.with_extra(extra).with_level(level)
  end
end

module Raven
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
