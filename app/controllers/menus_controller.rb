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
        pdf_class = Menu::Templates.pdf_class_for @menu.template
        pdf = pdf_class.new menu: @menu
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
        preview_params = menu_params.merge(establishment: @establishment)
        pdf = MenuPreviewGenerator.generate preview_params, current_ability
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
    parameters = params.require(:menu).permit(
      :id,
      :name,
      :template,
      :font,
      :font_size,
      :number_of_columns,
      :availability_start_time,
      :availability_end_time,
      :restricted_availability,
      :show_logo,
      {
        menu_lists_attributes: [
          :id,
          :list_id,
          :position,
          :show_price_on_menu,
          :display_name,
          :_destroy,
          { items_with_images: [] }
        ]
      }
    )

    if ['0', 'false'].include?(parameters.delete(:restricted_availability))
      # Unrestricted
      parameters[:availability_start_time] = nil
      parameters[:availability_end_time] = nil
    end

    parameters.fetch(:menu_lists_attributes, {}).each do |_, attrs|
      attrs[:list_item_metadata] = {
        items_with_images: Array(attrs.delete(:items_with_images))
      }

      attrs[:list_item_metadata][:display_name] = attrs.delete(:display_name) if attrs[:display_name].present?
      attrs.permit!
    end
    parameters
  end
end
