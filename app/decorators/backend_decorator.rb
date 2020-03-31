class BackendDecorator < Draper::Decorator
  include Backend::BaseDecorator
  include Backend::HeadingDecorator
  include Backend::TableDecorator
  include Backend::FormDecorator
  include Backend::FormFieldDecorator
  include Backend::LocalizationDecorator
  #include Backend::ActionDecorator

  NO_VALUE = '---'.freeze

  # This clashes with concrete decorator-class for instances
  # def self.collection_decorator_class
  #   Backend::PaginationDecorator
  # end

  delegate_all
end
