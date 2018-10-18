class ListsController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :establishment, through: :account
  load_and_authorize_resource :list, through: :establishment, except: :edit

  def new
    @list.name = 'New List'
    @list.establishment = @establishment
  end

  def edit
    @list = List
      .accessible_by(current_ability)
      .where(establishment: @establishment, id: params[:id])
      .includes(beers: { image_attachment: :blob })
      .first
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
      :description,
      {
        beers_attributes: [
          :id,
          :name,
          :price,
          :description,
          :position,
          { labels: [] },
          :image,
          :price_options,
          :_destroy
        ]
      }
    ).tap do |hsh|
      hsh[:beers_attributes].each do |(idx, beer_attrs)|
        beer_attrs.merge!(price_options: JSON.parse(beer_attrs[:price_options]))
      end
    end
  end
end
