class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource
  include PublicActivity::StoreController

  def render_default_modal_form(title = nil, target = nil, options = {})
    @title = title
    target ||= "#{params[:controller]}/#{params[:action]}"
    render :partial => "layouts/shared/default_modal_response", :locals => {:target => target, :options => options}
  end

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).reload.try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
 # creating one as needed
 def guest_user(with_retry = true)
   # Cache the value the first time it's gotten.
   @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

 rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user if with_retry
 end


  protected
  def layout_by_resource
    if devise_controller?
      "devise_layout"
    else
      "application"
    end
  end


  private

    # called (once) when the user logs in, insert any code your application needs
    # to hand off from guest_user to current_user.
    def logging_in
      guest_user_tournaments = guest_user.user_tournaments.all
      guest_user_tournaments.each do |user_tournament|
        user_tournament.user_id = current_user.id
        user_tournament.save!
      end
      
    end

    def create_guest_user
      u = User.create(:email => "guest_#{Time.now.to_i}#{rand(100)}@example.com")
      u.save!(:validate => false)
      session[:guest_user_id] = u.id
      u
    end

end
