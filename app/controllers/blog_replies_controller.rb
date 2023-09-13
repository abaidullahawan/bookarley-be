class BlogRepliesController < StoreController
  respond_to :html, :json

  def new
    @blog_reply = Spree::BlogReply.new
  end
  
  def create
    @blog_reply = Spree::BlogReply.new(review_params)

    respond_to do |format|
      if @blog_reply.save
        format.html { redirect_to blog_posts_path, notice: 'Blog was successfully uploaded.' }
        format.json { render json: @blog_reply, status: :created } # Return the newly created record
      else
        format.html { render :new }
        format.json { render json: { errors: @blog_reply.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @blog_reply = Spree::BlogReply.find(params[:id])

    if @blog_reply.destroy
      redirect_to manage_reviews_blog_posts_path, notice: 'Review was successfully deleted.'
    else
      redirect_to manage_reviews_blog_posts_path, alert: 'Failed to delete the blog post.'
    end
  end

  private

  def review_params
    params.permit(:name, :comment, :spree_blog_reviews_id)
  end

end
