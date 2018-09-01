class AccountsController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def edit
    @stripe_pub_key = ENV.fetch('STRIPE_PUB_KEY') {
      APP_CONFIG.dig(:stripe, :pub_key)
    }
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
    service = AccountUpdateService.call update_params
    if service.success?
      redirect_to @account, notice: 'Account updated'
    else
      @account = @account.decorate
      errors = service.error_messages
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

  def cancel
  end

  private

  def update_params
    {
      account: @account,
      ability: current_ability
    }.tap do |h|
      h.merge! as_sym_hash(account_params)
      h.merge! stripe_params
    end
  end

  def account_params
    params.require(:account).permit(
      :name,
      :active
    )
  end

  def stripe_params
    { stripe: as_sym_hash(params.fetch(:stripe, {})) }
  end

  def as_sym_hash(strong_params)
    strong_params.to_unsafe_h.symbolize_keys
  end
end
