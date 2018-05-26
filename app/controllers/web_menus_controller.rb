class WebMenusController < ApplicationController
  load_and_authorize_resource :account, except: :show
  load_and_authorize_resource :establishment, through: :account, except: :show
  load_and_authorize_resource :web_menu, through: :establishment, except: :show

  skip_before_action :verify_authenticity_token, :authenticate_user!, only: :show

  def new
    @web_menu.name = 'New Web Menu'
  end

  def create
    if @web_menu.valid?
      @web_menu.save
      redirect_to edit_account_establishment_web_menu_path(@account, @establishment, @web_menu), notice: 'Web menu created'
    else
      logger.debug("\n\nWeb Menu invalid! #{@web_menu.errors.full_messages}\n\n")
      render :new
    end
  end

  def edit
  end

  def update
    if @web_menu.update(web_menu_params)
      redirect_to edit_account_establishment_web_menu_path(@account, @establishment, @web_menu), notice: 'Web menu updated'
    else
      logger.debug("\n\nMenu invalid! #{@web_menu.errors.full_messages}\n\n")
      render :edit
    end
  end

  def show
    @web_menu = WebMenu.find params[:id]
    @web_menu_json_ld = JsonLdMenuSerializer.new({
      menu: @web_menu,
      url: request.referer
    }).call
    respond_to do |format|
      format.js
    end
  end

  def preview
    preview = WebMenuPreviewGenerator.new(web_menu_params, current_ability)
    @web_menu = preview.call
    render :show, layout: false
  end

  def destroy
    @web_menu.destroy
    redirect_to edit_account_establishment_path(@account, @establishment), notice: 'Web menu deleted'
  end

  private

  def web_menu_params
    parameters = params.require(:web_menu).permit(
      :id,
      :name,
      :availability_start_time,
      :availability_end_time,
      :restricted_availability,
      {
        web_menu_lists_attributes: [
          :id,
          :list_id,
          :position,
          :show_price_on_menu,
          :show_description_on_menu,
          :_destroy
        ]
      }
    )

    if ['0', 'false'].include?(parameters.delete(:restricted_availability))
      # Unrestricted
      parameters[:availability_start_time] = nil
      parameters[:availability_end_time] = nil
    end
    parameters
  end
end
