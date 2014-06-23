require 'csv'

module ActiveCSV
  class Base

    def initialize(row = nil)
      @row = normalize(row)
    end

    def method_missing(method_name, *args, &block)
      if @row.has_key?(method_name.to_s)
        @row[method_name.to_s]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      if @row.has_key?(method_name.to_s)
        true
      else
        super
      end
    end

    def self.file_path=(path)
      @file_path = path
    end

    def self.file_path
      @file_path
    end

    def self.field_prefix=(prefix)
      @field_prefix = prefix
    end

    def self.field_prefix
      @field_prefix
    end

    private

    def normalize(row)
      if row
        headers = row.headers.map do |header|
          if self.class.field_prefix
            header.downcase.split(" ").map { |column| column.strip }.join("_").gsub("#{self.class.field_prefix.to_s}", "")
          else
            header.downcase.split(" ").map { |column| column.strip }.join("_")
          end
        end
        fields = row.fields

        CSV::Row.new(headers, fields)
      end
    end

  end
end