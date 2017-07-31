class MenusController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :establishment, through: :account
  load_and_authorize_resource :menu, through: :establishment

  def new
    @menu.name = 'New Menu'
  end

  def show
    respond_to do |format|
      format.html
      format.pdf {
        pdf = MenuBasicPdf.new menu: @menu
        send_data pdf.render, {
          filename: pdf.filename,
          type: 'application/pdf',
          disposition: params.key?(:download) ? 'attachment' : 'inline'
        }
      }
    end
  end

  def preview
    respond_to do |format|
      format.pdf {
        pdf = MenuPreviewGenerator.generate menu_params, current_ability
        send_data pdf.render, {
          filename: pdf.filename,
          type: 'application/pdf',
          disposition: params.key?(:download) ? 'attachment' : 'inline'
        }
      }
    end
  end

  def edit
  end

  def create
    if @menu.valid?
      @menu.save
      redirect_to edit_account_establishment_menu_path(@account, @establishment, @menu), notice: 'Menu created'
    else
      logger.debug("\n\nMenu invalid! #{@menu.errors.full_messages}\n\n")
      render :new
    end
  end

  def update
    if @menu.update(menu_params)
      redirect_to edit_account_establishment_menu_path(@account, @establishment, @menu), notice: 'Menu updated'
    else
      logger.debug("\n\nMenu invalid! #{@menu.errors.full_messages}\n\n")
      render :edit
    end
  end

  def destroy
    @menu.destroy
    redirect_to edit_account_establishment_path(@account, @establishment), notice: 'Menu deleted'
  end

  private

  def menu_params
    params.require(:menu).permit(
      :id,
      :name,
      :font,
      :font_size,
      :number_of_columns,
      {
        menu_lists_attributes: [
          :id,
          :list_id,
          :position,
          :show_price_on_menu,
          :_destroy
        ]
      }
    )
  end
end
