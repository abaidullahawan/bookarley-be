class SlidersController < StoreController
  respond_to :html
  def index
    @sliders = Spree::Slider.order(priority: :asc).all
  end

  def show
    @slider = Spree::Slider.find(params[:id])
  end

  def new
    @slider = Spree::Slider.new
  end

  def create
    @slider = Spree::Slider.new(slider_params)
    if @slider.save
      redirect_to sliders_path, notice: 'Slider was successfully uploaded.'
    else
      render :new
    end
  end

  def edit
    @slider = Spree::Slider.find(params[:id])
  end

  def update
    @slider = Spree::Slider.find(params[:id])
    if @slider.update(slider_params)
      redirect_to sliders_path, notice: 'Slider was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @slider = Spree::Slider.find(params[:id])

    if @slider.destroy
      redirect_to sliders_path, notice: 'Slider was successfully deleted.'
    else
      redirect_to sliders_path, alert: 'Failed to delete the blog post.'
    end
  end

  private

  def slider_params
    params.require(:slider).permit(:title, :priority, :url, :image)
  end

end
