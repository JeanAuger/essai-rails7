class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:show]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :approve, :disapprove]

  def index
    logger.info "#{__FILE__}-index with search filter [#{params[:name]}]"

    if !params[:name] or params[:name].blank?
      # => RETURN ALL
      @courses = Course.published.approved.all
    else
      # => WE FILTER
      # STEP 10 -- FuzzyMatch.new creates a matcher obj
      f_matcher = FuzzyMatch.new(
        Course.published.approved.all, 
        :read => :name # matches according to the name fields
      )
      # STEP 20 -- find_all gets all matches as opposed to find
      @courses = f_matcher.find_all(params[:name]) # matches fuzzily course names...
      logger.debug "TROLL filtered #{@courses}"
    end

    # Turbo_stream -- to update only a specific part of the DOM
    respond_to do |format|
      format.html #{ notice: "Filtred with '#{params[:name]}'"}
      format.turbo_stream {

        render turbo_stream: turbo_stream.replace(
          'coursesTurboTag', 
          partial: 'courses', # rerender only the partial for the courses list
          locals: { courses: @courses }
        ) 
      }
    end
  end

  def purchased
    @courses = Course.joins(:subscriptions).where(subscriptions: {user: current_user})
    render 'index'
  end
  
  def pending_review
    @courses = Course.joins(:subscriptions).merge(Subscription.pending_review.where(user: current_user))
    render 'index'
  end

  def created
    @courses = Course.where(user_id: current_user.id).order(created_at: :desc)
    render 'index'
  end

  def published_unapproved
    @courses = Course.published.unapproved.order(updated_at: :desc)
    authorize @courses, :approve?
    render 'index'
  end

  def latest
    @courses = Course.all.published.approved.order(created_at: :desc)
    render 'index'
  end

  def top_rated
    @courses = Course.all.published.approved.order(average_rating: :desc, created_at: :desc)
    render 'index'
  end

  def popular
    @courses = Course.all.published.approved.order(subscriptions_count: :desc, created_at: :desc)
    render 'index'
  end

  def approve
    authorize @course, :approve?
		#@event.update_attribute(:status, 'planned')
		@course.update_attribute(:approved, true)
		redirect_to @course, notice: "Course '#{@course.name}' - approved"
  end

  def disapprove
    authorize @course, :approve?
		@course.update_attribute(:approved, false)
		redirect_to @course, alert: "Course '#{@course.name}' - disapproved"
  end

  def show
    authorize @course, :show?
    @lessons = @course.lessons.rank(:row_order)
    @subscriptions = @course.subscriptions.where.not(rating: 0, comment: nil).order(created_at: :desc)
  end

  def new
    @course = Course.new
    authorize @course
  end

  def edit
    authorize @course
  end

  def create
    @course = Course.new(course_params)
    @course.user_id = current_user.id
    authorize @course

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @course
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @course
    @course.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_course
      @course = Course.friendly.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:name, :category_id, :short_description, :description, :language, :duration, :price, :published, :level)
    end
end
