class StaticPagesController < ApplicationController
  def landing_page
  end

  def privacy_policy
  end

  def calender
    @users = User.order(email: :asc)
    @classrooms = Classroom.order(id: :desc)
    @courses = Course.order(id: :desc)

    if params.has_key?(:user_id)
      lessons = Lesson.includes(:user, :classroom, :course, :attendances)
      @user = params[:user_id]
      @classroom = params[:classroom_id]
      @course = params[:course_id]

      if params[:user_id].present?
        lessons = lessons.where(user_id: params[:user_id])
      end
      if params[:classroom_id].present?
        lessons = lessons.where(classroom_id: params[:classroom_id])
      end
      if params[:course_id].present?
        lessons = lessons.where(course_id: params[:course_id])
      end
      @lessons = Lesson.all
    else
      @lessons = Lesson.includes(:user, :classroom, :course, :attendances)
    end
  end
end
