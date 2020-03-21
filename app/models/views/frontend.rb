module Views
  class Frontend
    attr_reader :view, :params, :controller, :current_user

    def initialize(view_context)
      @view = view_context
      @params = @view.params
      @controller = @view.controller
      @controller_name = view.controller_name
      @action_name = view.action_name
      #@current_user = view&.current_user
    end

    def qualified_controller_name
      @params[:controller] || @controller_name
    end

    def section_style
      "#{qualified_controller_name}-#{@action_name}".parameterize # => e.g. 'frontend-pages-index'
    end

    # NOTE: The usual way of doing this in a view would be:
    # yield(:title) if content_for?(:title)
    def title
      return @view.content_for(:title) if @view.content_for?(:title)

      App::Config::TITLE
    end

    def description
      @view.content_for?(:description) ? @view.content_for(:description) : title
    end

    def theme
      user_theme || 'default'
    end

    # rubocop:disable Style/SafeNavigation
    def user_theme
      @current_user && @current_user.try(:theme)
    end
    # rubocop:enable Style/SafeNavigation
  end
end
