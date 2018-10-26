class DigitalDisplayMenusController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :establishment, through: :account
  load_and_authorize_resource :digital_display_menu, through: :establishment

  def new
    @digital_display_menu.name = 'New Digital Display Menu'
  end

  def show
    render :show, layout: 'digital_display'
  end

  def preview
    preview = DigitalDisplayMenuPreviewGenerator.new digital_display_menu_params, current_ability
    @digital_display_menu = preview.call
    logger.debug "lists: #{@digital_display_menu.lists.size}"
    render :show, layout: 'digital_display'
  end

  def edit
  end

  def update
    if @digital_display_menu.update digital_display_menu_params
      redirect_to edit_account_establishment_digital_display_menu_path(@account, @establishment, @digital_display_menu), notice: 'Digital display menu updated'
    else
      logger.debug("\n\nDigital display menu invalid! #{@digital_display_menu.errors.full_messages}\n\n")
      render :edit
    end
  end

  def create
    if @digital_display_menu.valid?
      @digital_display_menu.save
      redirect_to edit_account_establishment_digital_display_menu_path(@account, @establishment, @digital_display_menu), notice: 'Digital display menu created'
    else
      logger.debug("\n\nDigital display menu invalid! #{@digital_display_menu.errors.full_messages}\n\n")
      render :new
    end
  end

  def destroy
    @digital_display_menu.destroy
    redirect_to edit_account_establishment_path(@account, @establishment), notice: 'Digital display menu deleted'
  end

  private

  def digital_display_menu_params
    parameters = params.require(:digital_display_menu).permit(
      :id,
      :name,
      :horizontal_orientation,
      :rotation_interval,
      :font,
      :background_color,
      :text_color,
      :list_title_color,
      :theme,
      {
        digital_display_menu_lists_attributes: [
          :id,
          :list_id,
          :position,
          :show_price_on_menu,
          :display_name,
          :_destroy
        ]
      }
    )

    parameters.fetch(:digital_display_menu_lists_attributes, {}).each do |_, attrs|
      attrs[:list_item_metadata] = {}
      attrs[:list_item_metadata][:display_name] = attrs.delete(:display_name) if attrs[:display_name].present?
      attrs.permit!
    end

    parameters
  end
end
