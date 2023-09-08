class BlogPostsController < StoreController
  respond_to :html
  def index
    @blog_posts = Spree::BlogPost.all
  end

  def show
    @blog_post = Spree::BlogPost.find(params[:id])
  end

  def new
    @blog_post = Spree::BlogPost.new
  end

  def create
    @blog_post = Spree::BlogPost.new(blog_post_params)
    if @blog_post.save
      redirect_to blog_posts_path, notice: 'Blog was successfully uploaded.'
    else
      render :new
    end
  end

  def edit
    @blog_post = Spree::BlogPost.find(params[:id])
  end

  def update
    @blog_post = Spree::BlogPost.find(params[:id])
    if @blog_post.update(blog_post_params)
      redirect_to blog_posts_path, notice: 'Blog was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @blog_post = Spree::BlogPost.find(params[:id])

    if @blog_post.destroy
      redirect_to blog_posts_path, notice: 'Blog post was successfully deleted.'
    else
      redirect_to blog_posts_path, alert: 'Failed to delete the blog post.'
    end
  end

  def blog_list
    @blog_posts = Spree::BlogPost.all
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:title, :blog_overview, :description, :url, :image)
  end

end
