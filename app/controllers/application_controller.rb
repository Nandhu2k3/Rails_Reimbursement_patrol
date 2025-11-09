class ApplicationController < ActionController::Base
    # Protect all non-GET form submissions from CSRF attacks.
    protect_from_forgery with: :exception
  
    # Make these methods available in views (e.g., we can call current_user in ERB).
    helper_method :current_user, :logged_in?, :current_company, :current_employee
  
    private
  
    # Returns the currently logged-in user based on the user_id stored in the session.
    def current_user
      # Memoize (@current_user ||= ...) so we only hit the database once per request.
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  
    # Returns true if there is a user logged in.
    def logged_in?
      # Double negation (!!) converts the object to a boolean.
      !!current_user
    end
  
    # Returns the company of the current user.
    def current_company
      # Safe navigation (&.) so this returns nil if current_user is nil.
      current_user&.company
    end
  
    # Returns the Employee profile that belongs to the current user, if any.
    def current_employee
      # Only employees have an employee profile; admins may not.
      current_user&.employee
    end
  
    # Before_action filter: require a logged-in user for protected pages.
    def require_login
      # If there is no logged-in user:
      unless logged_in?
        # Show a flash message to the user.
        flash[:alert] = "You must be logged in to access this page."
        # Redirect them to the login page.
        redirect_to login_path
      end
    end
  
    # Before_action filter: only allow admins.
    def require_admin
      # If user is not logged in or not an admin:
      unless logged_in? && current_user.admin?
        # Tell the user they are not allowed.
        flash[:alert] = "Not authorized to access this page."
        # Send them somewhere safe:
        redirect_to root_path
      end
    end
  
    # Before_action filter: only allow employees.
    def require_employee
      # If user is not logged in or not an employee:
      unless logged_in? && current_user.employee?
        # Tell the user they are not allowed.
        flash[:alert] = "Not authorized to access this page."
        # Send them somewhere safe:
        redirect_to root_path
      end
    end
  end