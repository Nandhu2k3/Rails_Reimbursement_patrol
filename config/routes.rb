Rails.application.routes.draw do
  # Root of the app:
  # When user visits "/", show the login page.
  root to: "sessions#new"

  # Authentication routes:
  # Show login form.
  get  "/login",  to: "sessions#new"
  # Handle login form submission.
  post "/login",  to: "sessions#create"
  # Log the user out (expects method: :delete).
  delete "/logout", to: "sessions#destroy"

  # Signup routes (allowed only if email is whitelisted).
  # Show signup form.
  get  "/signup", to: "registrations#new"
  # Handle signup submission.
  post "/signup", to: "registrations#create"

  # Employee-facing bill routes.
  # Employees can:
  # - see their own bills (index)
  # - create new bills (new, create)
  resources :bills, only: [:index, :new, :create]

  # Admin namespace: all URLs start with /admin/...
  namespace :admin do
    # Admin dashboard home.
    get "/dashboard", to: "dashboard#show"

    # CRUD for employees (managed by admin).
    resources :employees

    # CRUD for departments; we skip :show for simplicity.
    resources :departments, except: [:show]

    # Allowed emails: manage whitelist.
    resources :allowed_emails, only: [:index, :new, :create, :destroy]

    # Bills for admin:
    # - index: see all bills
    # - show: see one bill
    # - approve/reject: change status
    resources :bills, only: [:index, :show] do
      # Member routes operate on one specific bill.
      member do
        # Approve this bill.
        patch :approve
        # Reject this bill.
        patch :reject
      end
    end
  end
end