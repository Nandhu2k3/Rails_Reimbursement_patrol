class RegistrationsController < ApplicationController
    # Show signup form.
    def new
      # Build an empty user object for the form.
      @user = User.new
    end
  
    # Handle signup submission.
    def create
      # Read email from the form.
      email = params[:user][:email]
  
      # Check if this email is whitelisted for signup.
      allowed = AllowedEmail.find_by(email: email)
  
      # If email is not present in AllowedEmail, block signup.
      if allowed.nil?
        flash.now[:alert] = "Email not registered. Please contact admin."
        @user = User.new
        return render :new
      end
  
      # Build new user using company + role from AllowedEmail.
      @user = User.new(
        name: params[:user][:name],                       # Name from form
        email: email,                                     # Email from form
        role: allowed.role,                               # Role from whitelist ("admin" or "employee")
        company: allowed.company,                         # Company from whitelist
        password: params[:user][:password],               # Plain password from form
        password_confirmation: params[:user][:password_confirmation]
      )
  
      # Try to save the user.
      if @user.save
        # If there is an existing employee profile with this email and no user yet,
        # link that employee record to this newly created user.
        employee = Employee.find_by(
          company: @user.company,
          email: @user.email,
          user_id: nil
        )
        if employee
          employee.update(user: @user)
        end
  
        # Log the user in.
        session[:user_id] = @user.id
  
        # Redirect based on role.
        if @user.admin?
          redirect_to admin_dashboard_path, notice: "Admin account activated."
        else
          redirect_to bills_path, notice: "Account created successfully."
        end
      else
        # If validations fail, show errors and re-render signup form.
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :new
      end
    end
  end