class BlogReviewsController < StoreController
  respond_to :html, :json

  def new
    @blog_review = Spree::BlogReview.new
  end
  
  def create
    @blog_review = Spree::BlogReview.new(review_params)

    random_color = generate_contrasting_color
    @blog_review.bg_color = random_color

    respond_to do |format|
      if @blog_review.save
        format.html { redirect_to blog_posts_path, notice: 'Blog was successfully uploaded.' }
        format.json { render json: @blog_review, status: :created } # Return the newly created record
      else
        format.html { render :new }
        format.json { render json: { errors: @blog_review.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def review_params
    params.permit(:name, :city, :comment, :spree_blog_post_id, :rating, :bg_color)
  end

  def generate_contrasting_color
    loop do
      random_color = "#" + SecureRandom.hex(3)
      r, g, b = random_color.scan(/\w\w/).map(&:hex)
      luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255

      # Check if the luminance is suitable for white text (adjust the threshold as needed)
      return random_color if luminance >= 0.5
    end
  end
end
