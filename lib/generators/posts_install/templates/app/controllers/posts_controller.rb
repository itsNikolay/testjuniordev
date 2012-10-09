class PostsController < ApplicationController
  def index
    @posts = Post.published

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.published?
        format.html # show.html.erb
        format.json { render json: @post }
      else
        format.html { redirect_to posts_path, alert: 'Post is not exist or unpublished yet.' }
      end
    end
  end
end
