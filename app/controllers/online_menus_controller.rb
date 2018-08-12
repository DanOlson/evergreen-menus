class OnlineMenusController < ApplicationController
  load_and_authorize_resource :account, except: :show
  load_and_authorize_resource :establishment, through: :account, except: :show
  load_and_authorize_resource :online_menu, through: :establishment, except: :show, singleton: true
  check_entitlements :online_menu

  def edit
  end

  def update
    if @online_menu.update online_menu_params
      GoogleMyBusiness::LocationUpdateService.new(establishment: @establishment).call
      redirect_to edit_account_establishment_online_menu_path(@account, @establishment, @online_menu), notice: 'Online Menu updated'
    else
      logger.debug("\n\nOnline Menu invalid! #{@online_menu.errors.full_messages}\n\n")
      render :edit
    end
  end

  def preview
    preview = OnlineMenuPreviewGenerator.new online_menu_params, current_ability
    @online_menu = preview.call
    render :preview, layout: 'facebook_menu_tab'
  end

  private

  def online_menu_params
    params.require(:online_menu).permit(
      :id,
      {
        online_menu_lists_attributes: [
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
