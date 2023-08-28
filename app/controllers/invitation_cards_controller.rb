# frozen_string_literal: true

class InvitationCardsController < StoreController
  respond_to :html

  def index
    @invitation_cards = InvitationCard.all
  end

  def new
    @invitation_card = InvitationCard.new
  end

  def create
    @invitation_card = InvitationCard.new(invitation_card_params)
    if @invitation_card.save
      redirect_to invitation_cards_path, notice: 'Invitation Card was successfully uploaded.'
    else
      render :new
    end
  end

  def edit
    @invitation_card = InvitationCard.find(params[:id])
  end

  def update
    @invitation_card = InvitationCard.find(params[:id])
    if @invitation_card.update(invitation_card_params)
      redirect_to invitation_cards_path, notice: 'Invitation Card was successfully updated.'
    else
      render :edit
    end
  end

  def add_text
    @invitation_card = InvitationCard.find(params[:id])

  end

  def save_template
    @invitation_card = InvitationCard.find(params[:id])
    @invitation_card.update(canvas_data: params[:canvas_data])
  end

  private

  def invitation_card_params
    params.require(:invitation_card).permit(:card_name, :image, :canvas_data)
  end
end
