class ApplicationController < ActionController::API

  protected

  def render_unprocessable_entity(exception)
    errors = exception.respond_to?(:errors) ? exception.errors : [exception.message]
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

end
