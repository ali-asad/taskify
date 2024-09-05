class CommentsController < ApplicationController
  before_action :set_task, only: [:new, :create, :edit, :update]

  def new
    @comment = @task.comments.build
  end

  def show
    @comment = Comment.new
    @comments = current_user.admin? ? @task.comments.includes(:user) : @task.comments.where(user: current_user).includes(:user)
  end
  

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to task_path(@task), notice: 'Comment was successfully created.'
    else
      render :new
    end
  end

  def edit
    @comment = @task.comments.find(params[:id])
  end

  def update
    @comment = @task.comments.find(params[:id])
    if @comment.update(comment_params)
      redirect_to task_path(@task), notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to task_path(@comment.task), notice: 'Comment was successfully deleted.'
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
