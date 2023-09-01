# frozen_string_literal: true

class InvitationCategoriesController < StoreController
  respond_to :html

  def index
    @invitation_categories = InvitationCategory.all
  end

  def new
    @invitation_category = InvitationCategory.new
  end

  def create
    @invitation_category = InvitationCategory.new(invitation_categories_params)
    if @invitation_category.save
      redirect_to invitation_cards_path, notice: 'Invitation Category was successfully uploaded.'
    else
      render :new
    end
  end

  def edit
    @invitation_category = InvitationCategory.find(params[:id])
  end

  def update
    @invitation_category = InvitationCategory.find(params[:id])
    if @invitation_category.update(invitation_categories_params)
      redirect_to invitation_cards_path, notice: 'Invitation Category was successfully updated.'
    else
      render :edit
    end
  end


  private

  def invitation_categories_params
    params.require(:invitation_category).permit(:name, :parent_id, :image)
  end
end
