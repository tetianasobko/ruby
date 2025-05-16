class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        # Assign selected teachers to this course
        if params[:course][:teacher_ids].present?
          teacher_ids = params[:course][:teacher_ids].reject(&:blank?)
          Teacher.where(id: teacher_ids).update_all(course_id: @course.id)
        end
        
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        # Handle teacher assignments for existing course
        if params[:course][:teacher_ids].present?
          # Get the selected teacher IDs, ignoring blanks
          teacher_ids = params[:course][:teacher_ids].reject(&:blank?)
          
          # Get current teachers that should no longer be associated
          current_teacher_ids = @course.teachers.pluck(:id)
          
          # Remove course_id from teachers no longer associated
          Teacher.where(id: current_teacher_ids - teacher_ids.map(&:to_i))
                .update_all(course_id: nil) if current_teacher_ids.any?
          
          # Assign course_id to newly selected teachers
          Teacher.where(id: teacher_ids).update_all(course_id: @course.id)
        else
          # If no teachers selected, remove all teacher associations
          @course.teachers.update_all(course_id: nil)
        end
        
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_path, status: :see_other, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # PATCH /courses/1/add_teacher
  def add_teacher
    @course = Course.find(params[:id])
    
    if params[:teacher_id].present?
      teacher = Teacher.find(params[:teacher_id])
      teacher.update(course_id: @course.id)
      redirect_to @course, notice: "Teacher was successfully added to course."
    else
      redirect_to @course, alert: "Please select a teacher to add."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:title, teacher_ids: [])
    end
end
