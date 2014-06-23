require 'csv'

module ActiveCSV
  class Base

    def initialize(row = nil)
      @row = row
    end

    def method_missing(method_name, *args, &block)
      if @row[method_name.to_s]
        @row[method_name.to_s]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      if @row[method_name.to_s]
        true
      else
        super
      end
    end

  end
end