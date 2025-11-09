class BillsController < ApplicationController
    # Ensure only logged-in users can access.
    before_action :require_login
    # Ensure only employees reach these actions.
    before_action :require_employee
  
    # GET /bills
    def index
      # Bills submitted by the current employee for their company.
      @bills = current_company
                 .bills
                 .where(employee: current_employee)
                 .order(created_at: :desc)
  
      # Summary tiles: total amounts (not counts).
      @total_submitted_amount = @bills.sum(:amount)
      @total_approved_amount  = @bills.where(status: "approved").sum(:amount)
    end
  
    # GET /bills/new
    def new
      # New bill form object.
      @bill = current_company.bills.new
    end
  
    # POST /bills
    def create
      # Build a new bill under the current company with safe params.
      @bill = current_company.bills.new(bill_params)
  
      # Attach currently logged-in employee as submitter.
      @bill.employee = current_employee
  
      # Record submission time and initial status.
      @bill.submitted_at = Time.current
      @bill.status       = "pending"
  
      if @bill.save
        redirect_to bills_path, notice: "Bill submitted successfully."
      else
        flash.now[:alert] = @bill.errors.full_messages.to_sentence
        render :new
      end
    end
  
    private
  
    # Only allow trusted params.
    def bill_params
      params.require(:bill).permit(:amount, :bill_type)
    end
  end