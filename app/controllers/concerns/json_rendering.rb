module JsonRendering
  extend ActiveSupport::Concern

  def render_json(result = {})
    render json: result, status: :ok
  end

  alias render_json_success render_json

  def render_json_unprocessable(result = {})
    render json: result, status: :unprocessable_entity
  end

  def render_json_error(result = {})
    render json: result, status: '500'
  end

  def render_json_forbidden(error_or_plain_message, additional_result = {})
    response = error_or_plain_message
    response = { error: response } unless response.is_a?(Hash)
    render json: response.merge(Hash(additional_result)), status: :forbidden
  end

  def render_json_partial(partial_path, locals = {})
    render json: { markup: render_to_string(partial: partial_path, locals: locals) }, layout: false
  end

  def render_json_markup(markup)
    render json: { markup: markup }, layout: false
  end

  private def ensure_json_request
    return if request.format == :json

    render nothing: true, status: :not_acceptable
  end
end
