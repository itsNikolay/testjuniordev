class PostsController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :show, :today]
  before_filter :postOwner?, only: [:edit, :update, :destroy]

  def published
    Post.update_all(["published=?", true], :id => params[:post_ids])
    redirect_to myposts_path, notice: 'Posts was successfully unpublished.'
  end

  def myposts
    @posts = Post.by_current_user(current_user).page(params[:page]).per(5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def today
    @posts = Post.today.published.page(params[:page]).per(5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def index
    @posts = Kaminari.paginate_array(Post.all).page(params[:page]).per(5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @commentable = @post
    @comments = @commentable.comments
    @comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])

  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    @post.published = true

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])

     respond_to do |format|
      if @post.published == false
        @post.destroy
        format.html { redirect_to posts_url }
        format.json { head :no_content }
      else
        format.html { redirect_to posts_url, alert: 'You can not delete published post.' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
  end


end

private
  def postOwner?
     redirect_to root_path, alert: 'The Post can edit only its own publisher.' unless Post.find(params[:id]).user_id == current_user.id
  end

end
