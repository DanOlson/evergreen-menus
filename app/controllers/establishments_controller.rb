class EstablishmentsController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :establishment, through: :account

  def new
  end

  def create
    if @establishment.valid?
      @establishment.account = @account
      @establishment.save
      redirect_to @account, notice: "Establishment created"
    else
      logger.debug "Errors creating establishment: #{@establishment.errors.full_messages}"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @establishment.update establishment_params
      redirect_to @account, notice: 'Establishment updated'
    else
      logger.debug "Errors updating establishment: #{@establishment.errors.full_messages}"
      render :edit
    end
  end

  def destroy
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
