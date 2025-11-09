# This controller handles the admin dashboard page.
# All URLs for this controller are under /admin (because of the namespace in routes).
class Admin::DashboardController < ApplicationController
    # Make sure someone is logged in before they see this page.
    before_action :require_login
  
    # Make sure only admins can access this controller.
    before_action :require_admin
  
    # GET /admin/dashboard
    def show
      # The current_company helper comes from ApplicationController.
      # It returns the company of the logged-in user.
      @company = current_company
  
      # Count how many employees exist in this company.
      @employees_count = @company.employees.count
  
      # Count all bills belonging to this company.
      @bills_count = @company.bills.count
  
      # Count only pending bills (useful KPI for admin).
      @pending_bills_count = @company.bills.where(status: "pending").count
  
      # Rails will render app/views/admin/dashboard/show.html.erb by default.
    end
  end