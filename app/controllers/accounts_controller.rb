class AccountsController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def create
    if @account.valid?
      @account.save
      redirect_to @account, notice: 'Account created'
    else
      errors = @account.errors.full_messages
      logger.debug "Errors creating account: #{errors}"
      flash.now[:alert] = errors.join(', ')
      render :new
    end
  end

  def show
  end

  def index
  end

  private

  def account_params
    params.require(:account).permit(:name, :active)
  end
end
