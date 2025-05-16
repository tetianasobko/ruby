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
    @teacher.course_id = params[:teacher][:course_id] if params[:teacher] && params[:teacher][:course_id]
  end

  # GET /teachers/1/edit
  def edit
  end

  # POST /teachers or /teachers.json
  def create
    @teacher = Teacher.new(teacher_params)

    if @teacher.save
      flash[:notice] = "Teacher was successfully created."
      redirect_to @teacher.course
    else
      render :new
    end
  end

  # PATCH/PUT /teachers/1 or /teachers/1.json
  def update
    if @teacher.update(teacher_params)
      flash[:notice] = "Teacher was successfully updated."
      redirect_to @teacher.course
    else
      render :edit
    end
  end

  # DELETE /teachers/1 or /teachers/1.json
  def destroy
    course = @teacher.course
    @teacher.destroy
    flash[:notice] = "Teacher was successfully deleted."
    redirect_to course
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def teacher_params
      params.require(:teacher).permit(:name, :course_id)
    end
end
