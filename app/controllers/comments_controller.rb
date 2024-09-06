class CommentsController < ApplicationController
  before_action :set_task
  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
    if @task.comments.where(user_id: current_user.id).exists?
      flash[:alert] = "You have already commented on this task."
      redirect_to task_path(@task)
    else
      @comment = @task.comments.new
    end
  end

  def show
    @comment = Comment.new
    @comments = current_user.admin? ? @task.comments.includes(:user) : @task.comments.where(user: current_user).includes(:user)
  end
  

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @task.comments.where(user_id: current_user.id).exists?
      flash[:alert] = "You can only add one comment per task."
      redirect_to task_path(@task)
    elsif @comment.save
      flash[:notice] = "Comment added successfully."
      redirect_to task_path(@task)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @comment = @task.comments.find(params[:id])
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = "Comment updated successfully."
      redirect_to task_path(@task)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    flash[:notice] = "Comment deleted successfully."
    redirect_to task_path(@task)
  end

  private

  def set_comment
    @comment = @task.comments.find(params[:id])
  end

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
