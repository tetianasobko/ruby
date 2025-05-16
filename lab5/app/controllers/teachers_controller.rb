class TeachersController < ApplicationController
  before_action :set_teacher, only: %i[ show edit update destroy ]

  # GET /teachers or /teachers.json
  def index
    @teachers = Teacher.all
  end

  # GET /teachers/1 or /teachers/1.json
  def show
  end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
    # Store course_id in instance variable for form if coming from a course
    @course_id = params[:course_id] if params[:course_id]
  end

  # GET /teachers/1/edit
  def edit
  end

  # POST /teachers or /teachers.json
  def create
    @teacher = Teacher.new(teacher_params.except(:course_ids))

    if @teacher.save
      # Handle course associations if present
      if params[:teacher][:course_ids].present?
        course_ids = Array(params[:teacher][:course_ids]).reject(&:blank?)
        @teacher.course_ids = course_ids
      end
      
      flash[:notice] = "Teacher was successfully created."
      
      # Redirect to the first course if associated, otherwise to teachers list
      if @teacher.courses.any?
        redirect_to @teacher.courses.first
      else
        redirect_to teachers_path
      end
    else
      render :new
    end
  end

  # PATCH/PUT /teachers/1 or /teachers/1.json
  def update
    if @teacher.update(teacher_params.except(:course_ids))
      # Handle course associations if present
      if params[:teacher][:course_ids].present?
        course_ids = Array(params[:teacher][:course_ids]).reject(&:blank?)
        @teacher.course_ids = course_ids
      end
      
      flash[:notice] = "Teacher was successfully updated."
      
      # Redirect to the first course if associated, otherwise to teachers list
      if @teacher.courses.any?
        redirect_to @teacher.courses.first
      else
        redirect_to @teacher
      end
    else
      render :edit
    end
  end

  # DELETE /teachers/1 or /teachers/1.json
  def destroy
    @teacher.destroy
    flash[:notice] = "Teacher was successfully deleted."
    redirect_to teachers_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def teacher_params
      params.require(:teacher).permit(:name, course_ids: [])
    end
end
