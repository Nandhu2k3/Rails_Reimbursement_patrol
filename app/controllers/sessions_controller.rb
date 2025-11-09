class SessionsController < ApplicationController
    # Show the login page.
    def new
      # If the user is already logged in, we don't need to show login again.
      if logged_in?
        # Redirect admins to admin dashboard.
        return redirect_to admin_dashboard_path if current_user.admin?
        # Redirect employees to their bills page.
        return redirect_to bills_path if current_user.employee?
      end
  
      # If not logged in, just render the login form (new.html.erb).
    end
  
    # Handle login form submission.
    def create
      # Find the user by email (case-insensitive match).
      user = User.find_by(email: params[:email])
  
      # Check if user exists AND the password is correct.
      if user&.authenticate(params[:password])
        # Save the user_id in the session to mark them as logged in.
        session[:user_id] = user.id
  
        # Redirect based on role:
        if user.admin?
          redirect_to admin_dashboard_path, notice: "Logged in as admin."
        else
          redirect_to bills_path, notice: "Logged in successfully."
        end
      else
        # If email or password is wrong, show an error.
        flash.now[:alert] = "Invalid credentials."
        # Re-render the login form instead of redirecting, so the message shows.
        render :new
      end
    end
  
    # Handle logout.
    def destroy
      # Remove the logged-in user from the session.
      session[:user_id] = nil
  
      # Redirect back to the login page with a message.
      redirect_to login_path, notice: "Logged out successfully."
    end
  end