class Course < ApplicationRecord
  belongs_to :user
  belongs_to :classroom
  belongs_to :service
  has_many :lessons, dependent: :restrict_with_error

  has_many :enrollments, inverse_of: :course
  accepts_nested_attributes_for :enrollments, reject_if: :all_blank, allow_destroy: true

  has_many :users, through: :enrollments
  has_many :attendances, through: :lessons

  include Schedulable

  def schedule
    schedule = IceCube::Schedule.new(now = self.start_time&.to_datetime)
    schedule.add_recurrence_rule(
      IceCube::Rule.weekly.day(active_days)
      # IceCube::Rule.weekly.day_of_month(13).day(:friday).month_of_year(:october)
    )
    schedule
  end

  def to_s
    id
  end


end
