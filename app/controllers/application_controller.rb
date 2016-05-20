class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource

  def render_default_modal_form(title = nil, target = nil, options = {})
    @title = title
    target ||= "#{params[:controller]}/#{params[:action]}"
    render :partial => "layouts/shared/default_modal_response", :locals => {:target => target, :options => options}
  end

  protected
  def layout_by_resource
    if devise_controller?
      "devise_layout"
    else
      "application"
    end
  end
end
