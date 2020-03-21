module JsonBinaryAttributes
  extend ActiveSupport::Concern

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_jsonb_attributes(column_name, *attr_names)
      jsonb_columns << column_name
      serialize column_name, HashSerializer
      store_accessor column_name, *attr_names
      const_set(column_name.upcase, attr_names.freeze)
    end

    def jsonb_columns
      @jsonb_columns ||= []
    end
  end
end
