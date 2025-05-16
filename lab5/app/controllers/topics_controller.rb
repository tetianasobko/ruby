class TopicsController < ApplicationController
  before_action :set_topic, only: %i[ show edit update destroy ]

  # GET /topics or /topics.json
  def index
    @topics = Topic.all
  end

  # GET /topics/1 or /topics/1.json
  def show
  end

  # GET /topics/new
  def new
    @topic = Topic.new
    @topic.course_id = params[:topic][:course_id] if params[:topic] && params[:topic][:course_id]
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics or /topics.json
  def create
    @topic = Topic.new(topic_params)

    if @topic.save
      flash[:notice] = "Topic was successfully created."
      redirect_to @topic.course
    else
      render :new
    end
  end

  # PATCH/PUT /topics/1 or /topics/1.json
  def update
    if @topic.update(topic_params)
      flash[:notice] = "Topic was successfully updated."
      redirect_to @topic.course
    else
      render :edit
    end
  end

  # DELETE /topics/1 or /topics/1.json
  def destroy
    course = @topic.course
    @topic.destroy
    flash[:notice] = "Topic was successfully deleted."
    redirect_to course
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def topic_params
      params.require(:topic).permit(:name, :course_id)
    end
end
