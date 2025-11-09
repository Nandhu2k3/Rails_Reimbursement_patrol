class Admin::BillsController < ApplicationController
    # Only logged-in admins can review bills.
    before_action :require_login
    before_action :require_admin
    before_action :set_bill, only: [:show, :approve, :reject]
  
    # GET /admin/bills
    def index
      # All bills for this admin's company, newest first.
      @bills = current_company
                 .bills
                 .includes(employee: :department)
                 .order(created_at: :desc)
  
      # Summary tiles: total amounts (not counts).
      @total_submitted_amount = @bills.sum(:amount)
      @total_approved_amount  = @bills.where(status: "approved").sum(:amount)
    end
  
    # GET /admin/bills/:id
    def show
      # @bill is loaded by set_bill.
    end
  
    # PATCH /admin/bills/:id/approve
    def approve
      if @bill.pending?
        @bill.status      = "approved"
        @bill.reviewed_at = Time.current
        @bill.reviewer    = current_user
  
        if @bill.save
          redirect_to admin_bills_path, notice: "Bill approved."
        else
          redirect_to admin_bills_path, alert: @bill.errors.full_messages.to_sentence
        end
      else
        redirect_to admin_bills_path, alert: "Only pending bills can be approved."
      end
    end
  
    # PATCH /admin/bills/:id/reject
    def reject
      if @bill.pending?
        @bill.status      = "rejected"
        @bill.reviewed_at = Time.current
        @bill.reviewer    = current_user
  
        if @bill.save
          redirect_to admin_bills_path, notice: "Bill rejected."
        else
          redirect_to admin_bills_path, alert: @bill.errors.full_messages.to_sentence
        end
      else
        redirect_to admin_bills_path, alert: "Only pending bills can be rejected."
      end
    end
  
    private
  
    # Restrict lookup to bills in the current company.
    def set_bill
      @bill = current_company.bills.find(params[:id])
    end
  end