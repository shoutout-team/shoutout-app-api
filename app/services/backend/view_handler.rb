module Backend
  class ViewHandler
    attr_reader :view, :params, :controller, :current_user

    def initialize(view_context)
      @view = view_context
      @params = @view.params
      @controller = @view.controller
      @controller_name = view.controller_name
      @action_name = view.action_name
      @current_user = view.current_user
    end

    def qualified_controller_name
      @params[:controller] || @controller_name
    end

    def decorator
      BackendDecorator.new(nil)
    end

    def section_style
      # "#{@controller_name}--#{@action_name}".parameterize # => 'pages-index'
      "#{qualified_controller_name}-#{@action_name}".parameterize # => 'backend-pages-index'
    end

    # NOTE: The usual way of doing this in a view would be:
    # yield(:title) if content_for?(:title)
    def page_title
      return @view.content_for(:title) if @view.content_for?(:title)
    end

    def page_description
      @view.content_for?(:description) ? @view.content_for(:description) : page_title
    end

    def theme
      current_user.try(:backend_theme) || 'default'
    end
  end
end
