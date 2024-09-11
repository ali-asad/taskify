class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task, only: %i[edit update destroy show]
  
    def index
      if current_user.admin?
        @tasks = Task.all
        @users = User.where.not(id: current_user.id)
      else
        @tasks = current_user.tasks
      end
    end

    def show
      @task = Task.find(params[:id])
      @comments = @task.comments.includes(:user)
      @comment = current_user.comments.find_or_initialize_by(task: @task) if current_user == @task.user
    end       
  
    def new
      @task = Task.new
    end
  
    def create
      @task = Task.new(task_params)
      @task.priority = 'low'
      
      if @task.save
        redirect_to tasks_path, notice: "Task was successfully created."
      else
        render :new
      end
    end
  
    def edit
    end


    def update
      if task_params[:user_id]
        @task.comments.destroy_all if task_params[:user_id] && task_params[:user_id] != @task.user_id
        @task.status = 'pending'
      end

      if @task.update(task_params)
        redirect_to tasks_path, notice: "Task #{@task.title} was successfully updated."
      else
        render :edit
      end
    end
  
    def destroy
      @task.destroy
      redirect_to tasks_path, notice: "#{@task.title} was successfully deleted."
    end
  
    private
  
    def set_task
      @task = Task.find(params[:id])
    end
  
    def task_params
      params.require(:task).permit(:title, :description, :status, :user_id, :priority)
    end
  end
  