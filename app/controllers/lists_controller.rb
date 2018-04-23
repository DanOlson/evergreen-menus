class ListsController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :establishment, through: :account
  load_and_authorize_resource :list, through: :establishment

  def new
    @list.name = 'New List'
    @list.establishment = @establishment
  end

  def edit
  end

  def show
    render :json, @list.as_json.merge(beers: @list.beers.as_json)
  end

  def create
    if @list.valid?
      @list.save
      redirect_to edit_account_establishment_path(@account, @establishment), notice: 'List created'
    else
      errors = @list.errors.full_messages
      logger.debug "Errors creating list: #{errors}"
      flash.now[:alert] = errors.join(', ')
      render :new
    end
  end

  def update
    if @list.update list_params
      GoogleMyBusiness::LocationUpdateService.new(establishment: @establishment).call
      redirect_to edit_account_establishment_path(@account, @establishment), notice: 'List updated'
    else
      errors = @list.errors.full_messages
      logger.debug "Errors updating list: #{errors}"
      flash.now[:alert] = errors.join(', ')
      render :edit
    end
  end

  def destroy
    @list.destroy
    redirect_to edit_account_establishment_path(@account, @establishment), notice: 'List deleted'
  end

  private

  def list_params
    params.require(:list).permit(
      :id,
      :name,
      :type,
      { beers_attributes: [:id, :name, :price, :description, :position, { labels: [] }, :_destroy] }
    )
  end
end
