class Admin::EmployeesController < ApplicationController
    # Ensure a user is logged in before any action.
    before_action :require_login
  
    # Ensure only admins access this controller.
    before_action :require_admin
  
    # Load the employee for actions that need a specific record.
    before_action :set_employee, only: [:show, :edit, :update, :destroy]
  
    # Load departments for the form pages so we can show a dropdown.
    before_action :load_departments, only: [:new, :create, :edit, :update]
  
    # GET /admin/employees
    def index
      # List all employees that belong to the current admin's company.
      # includes(:department, :user) prevents N+1 queries when showing related data.
      @employees = current_company.employees.includes(:department, :user)
    end
  
    # GET /admin/employees/new
    def new
      # Build a new employee object scoped to the current company.
      @employee = current_company.employees.new
    end
  
    # POST /admin/employees
    def create
        # Build a new employee under the current company with the form params.
        @employee = current_company.employees.new(employee_params)
      
        if @employee.save
          # After creating an employee, ensure their email is whitelisted
          # so they can sign up and activate their account later.
          AllowedEmail.find_or_create_by!(
            company: current_company,
            email: @employee.email
          ) do |ae|
            # Default role for employees created here.
            ae.role = "employee"
          end
      
          redirect_to admin_employees_path, notice: "Employee created successfully and signup access granted."
        else
          flash.now[:alert] = @employee.errors.full_messages.to_sentence
          render :new
        end
      end
  
    # GET /admin/employees/:id
    def show
      # @employee is already loaded by set_employee.
      # View will display their details.
    end
  
    # GET /admin/employees/:id/edit
    def edit
      # @employee is already loaded by set_employee.
      # View will use @employee + @departments.
    end
  
    # PATCH/PUT /admin/employees/:id
    def update
      # Update the employee with permitted attributes.
      if @employee.update(employee_params)
        redirect_to admin_employees_path, notice: "Employee updated successfully."
      else
        flash.now[:alert] = @employee.errors.full_messages.to_sentence
        render :edit
      end
    end
  
    # DELETE /admin/employees/:id
    def destroy
      # Delete the employee record (per assignment: simple delete is fine).
      @employee.destroy
      redirect_to admin_employees_path, notice: "Employee deleted."
    end
  
    private
  
    # Load a specific employee inside the current company.
    # This prevents an admin from accessing employees from another tenant.
    def set_employee
      @employee = current_company.employees.find(params[:id])
    end
  
    # Load all departments for the current company to populate dropdowns.
    def load_departments
      # We order by name to keep the select neat.
      @departments = current_company.departments.order(:name)
    end
  
    # Strong parameters: define what fields are allowed from the form.
    def employee_params
        params.require(:employee).permit(
          :first_name,
          :last_name,
          :email,
          :designation,    # <-- allow this
          :department_id,
          :user_id
        )
      end
  end