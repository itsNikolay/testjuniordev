class Admin::CommentsController < Admin::BaseController
  def index
    #@posts = Post.published
    @comments = Comment.all(order: "updated_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to admin_comments_path, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to admin_comments_url, notice: "Comment ID ##{@comment.id} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

end
