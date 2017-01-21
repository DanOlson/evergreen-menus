class AccountsController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def index
  end

  def staff
    @staff = @account.users
  end
end
