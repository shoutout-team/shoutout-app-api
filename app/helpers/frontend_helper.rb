module FrontendHelper
  # rubocop:disable Rails/HelperInstanceVariable
  def frontend
    @frontend ||= Views::Frontend.new(self)
  end
  # rubocop:enable Rails/HelperInstanceVariable
end
