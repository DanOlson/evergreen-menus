class EstablishmentsController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :establishment, through: :account

  def new
  end

  def create
    if @establishment.valid?
      @establishment.account = @account
      @establishment.save
      redirect_to edit_account_establishment_path(@account, @establishment), notice: "Establishment created"
    else
      errors = @establishment.errors.full_messages
      logger.debug "Errors creating establishment: #{errors}"
      flash.now[:alert] = errors.join(', ')
      render :new
    end
  end

  def edit
  end

  def show
    redirect_to edit_account_establishment_path(@account, @establishment)
  end

  def update
    if @establishment.update establishment_params
      redirect_to edit_account_establishment_path(@account, @establishment), notice: 'Establishment updated'
    else
      errors = @establishment.errors.full_messages
      logger.debug "Errors updating establishment: #{errors}"
      flash.now[:alert] = errors.join(', ')
      render :edit
    end
  end

  def destroy
    @establishment.destroy
    redirect_to @account, notice: 'Establishment deleted'
  end

  private

  def establishment_params
    params.require(:establishment).permit(
      :name,
      :url,
      :street_address,
      :city,
      :state,
      :postal_code
    )
  end
end
