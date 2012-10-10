class CommentsController < ApplicationController
 before_filter :authenticate_user!, only: [:new, :create, :destroy]
 before_filter :load_commentable
 before_filter :edit_your_own_comment, only: [:edit, :update, :destroy]

  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(params[:comment])
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to @commentable, notice: "Comment created."
    else
      render :new
    end
  end

  def edit
    @comment = @commentable.comments.find(params[:id])
  end

  def update
    @comment = @commentable.comments.find(params[:id])
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @commentable, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Comment was successfully deleted." }
      format.json { head :no_content }
    end
  end

private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def edit_your_own_comment
    @comment = @commentable.comments.find(params[:id])
    redirect_to @commentable, :alert => 'Editing not your comment is allowed only for the comment publisher.' unless @comment.user == current_user
  end

end