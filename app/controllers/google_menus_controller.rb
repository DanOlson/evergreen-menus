class GoogleMenusController < ApplicationController
  load_and_authorize_resource :account, except: :show
  load_and_authorize_resource :establishment, through: :account, except: :show
  load_and_authorize_resource :google_menu, through: :establishment, except: :show, singleton: true

  def edit
  end

  def update
    if @google_menu.update google_menu_params
      # GoogleMyBusiness::LocationUpdateService.new(establishment: @establishment).call
      redirect_to edit_account_establishment_google_menu_path(@account, @establishment, @google_menu), notice: 'Google Menu updated'
    else
      logger.debug("\n\nGoogle Menu invalid! #{@google_menu.errors.full_messages}\n\n")
      render :edit
    end
  end

  def preview
    preview = GoogleMenuPreviewGenerator.new google_menu_params, current_ability
    @google_menu = preview.call
    render :preview, layout: false
  end

  private

  def google_menu_params
    params.require(:google_menu).permit(
      :id,
      {
        google_menu_lists_attributes: [
          :id,
          :list_id,
          :position,
          :show_price_on_menu,
          :show_description_on_menu,
          :_destroy
        ]
      }
    )
  end
end
