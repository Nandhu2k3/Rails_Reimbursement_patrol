# 💸 Rails Reimbursement Portal

An internal employee reimbursement portal built with **Ruby on Rails** (from scratch, no scaffolds) to demonstrate:

- Clean MVC design
- Proper authentication & authorization
- Multi-tenant company scoping
- Admin-driven onboarding
- A simple but friendly UI/UX

This is meant as an **assignment-quality** project you would hand to a product engineering team.

---

## 1. Core Concept

Employees can:

- Sign up **only** if pre-approved.
- Submit reimbursement bills.
- See **only their own** bills and statuses.

Admins can:

- Access an admin-only dashboard.
- Create departments.
- Create & manage employees.
- Configure which emails are allowed to sign up.
- See and review all bills for their company.
- Approve / reject bills.

All data is **scoped by company** for safety (multi-tenant style isolation).

---

## 2. Tech Stack

- **Ruby**: 2.5.3
- **Rails**: 5.2.8.1
- **Database**: PostgreSQL
- **Auth**: `has_secure_password` (BCrypt)
- **Frontend**: ERB views + custom CSS (no JS frameworks, no scaffolds)
- **Server**: Puma

---

## 3. Domain Model

### Tables / Models

- `Company`
  - One company (tenant).
  - Has many: users, employees, departments, allowed_emails, bills.

- `Department`
  - Belongs to a company.
  - Used to group employees.

- `User`
  - Login identity.
  - Fields: `name`, `email`, `role` (`admin` / `employee`), `password_digest`, `company_id`.
  - Uses `has_secure_password`.
  - Linked to `Employee` (for employees).

- `Employee`
  - HR profile for a person.
  - Fields: `first_name`, `last_name`, `email`, `designation`, `company_id`, `user_id`, `department_id`.
  - `belongs_to :company`, `belongs_to :department`, `belongs_to :user` (optional until signup).

- `AllowedEmail`
  - Whitelist for signup.
  - Fields: `email`, `role`, `company_id`.
  - Controls:
    - Who can sign up.
    - What role they get.
    - Which company they belong to.

- `Bill`
  - Reimbursement request.
  - Fields:
    - `amount` (decimal)
    - `bill_type` (`Food`, `Travel`, `Others`)
    - `status` (`pending`, `approved`, `rejected`)
    - `submitted_at`, `reviewed_at`
    - `company_id`, `employee_id`, `reviewed_by_user_id`
  - `belongs_to :company`
  - `belongs_to :employee`
  - `belongs_to :reviewer, class_name: "User", foreign_key: :reviewed_by_user_id`, optional.

Multi-tenancy rule: **Every query is scoped through `current_company`** to avoid cross-company access.

---

## 4. Key Features

### Authentication

- Login via `SessionsController`
- Registration via `RegistrationsController`
- Passwords stored using `has_secure_password`.
- No public signup:
  - Signup only works if email exists in `AllowedEmail`.

### Authorization (RBAC)

- `before_action :require_login`
- `before_action :require_admin` (for admin namespace)
- `before_action :require_employee` (for employee-only areas)

**Admins can:**

- Access `/admin/*` pages.
- Create / edit / delete `Employee` records.
- Manage `Departments`.
- Manage `AllowedEmail`.
- View all company `Bills`.
- Approve / reject bills.

**Employees can:**

- Access `/bills` and `/bills/new`.
- Submit bills.
- View only **their own** bills.
- Never see `/admin` pages.

### Bills Flow

1. Employee submits a bill:
   - Status → `pending`
   - Linked to `current_employee` & `current_company`
2. Admin sees all bills for their company.
3. Admin approves / rejects:
   - Sets `status`
   - Sets `reviewed_at`
   - Sets `reviewed_by_user_id`
4. Employee’s “My Bills” page reflects updated status.

---

## 5. How It All Fits (MVC Flow)

Example: **Employee views “My Bills”**

1. `GET /bills`
2. Routes → `BillsController#index`
3. Filters:
   - `require_login`
   - `require_employee`
4. Controller:
   ```ruby
   @bills = current_company
              .bills
              .where(employee: current_employee)
              .order(created_at: :desc)
