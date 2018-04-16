class AccountsController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def edit
    @account = @account.decorate
  end

  def create
    if @account.valid?
      @account.save
      redirect_to @account, notice: 'Account created'
    else
      errors = @account.errors.full_messages
      flash.now[:alert] = errors.join(', ')
      render :new
    end
  end

  def update
    update_params = account_params
    update_params.delete(:active) unless can?(:activate, @account)
    if @account.update update_params
      redirect_to @account, notice: 'Account updated'
    else
      errors = @account.errors.full_messages
      flash.now[:alert] = errors.join(', ')
      render :edit
    end
  end

  def show
  end

  def index
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice: 'Account deleted'
  end

  private

  def account_params
    params.require(:account).permit(
      :name,
      :active,
      :google_my_business_account_id
    )
  end
end
