class Admin::DepartmentsController < ApplicationController
    # Only logged-in admins can manage departments.
    before_action :require_login
    before_action :require_admin
  
    # Load the department for actions that need a specific record.
    before_action :set_department, only: [:edit, :update, :destroy]
  
    # GET /admin/departments
    def index
      # List all departments that belong to the current admin's company.
      @departments = current_company.departments.order(:name)
    end
  
    # GET /admin/departments/new
    def new
      # Build a new department scoped to current company.
      @department = current_company.departments.new
    end
  
    # POST /admin/departments
    def create
      # Create a department under the current company with form inputs.
      @department = current_company.departments.new(department_params)
  
      if @department.save
        # On success, go back to list.
        redirect_to admin_departments_path, notice: "Department created successfully."
      else
        # Show validation errors and re-render the form.
        flash.now[:alert] = @department.errors.full_messages.to_sentence
        render :new
      end
    end
  
    # GET /admin/departments/:id/edit
    def edit
      # @department loaded by set_department.
    end
  
    # PATCH/PUT /admin/departments/:id
    def update
      if @department.update(department_params)
        redirect_to admin_departments_path, notice: "Department updated successfully."
      else
        flash.now[:alert] = @department.errors.full_messages.to_sentence
        render :edit
      end
    end
  
    # DELETE /admin/departments/:id
    def destroy
      # Deleting a department will nullify department_id on employees (per model).
      @department.destroy
      redirect_to admin_departments_path, notice: "Department deleted."
    end
  
    private
  
    # Find department within the current company only (prevents cross-tenant access).
    def set_department
      @department = current_company.departments.find(params[:id])
    end
  
    # Strong params: only allow name.
    def department_params
      params.require(:department).permit(:name)
    end
  end