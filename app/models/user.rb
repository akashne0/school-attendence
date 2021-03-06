class User < ApplicationRecord
    include Roleable

    has_many :enrollments, dependent: :restrict_with_error
    has_many :lessons, dependent: :restrict_with_error
    has_many :attendances, dependent: :restrict_with_error
    has_many :courses, dependent: :restrict_with_error


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable, :invitable,
         :omniauthable, omniauth_providers: [:google_oauth2, :github, :twitter, :facebook]

   # for omni auth
   def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    unless user
      user = User.create(
         email: data['email'],
         password: Devise.friendly_token[0,20])
    end
    user.provider = access_token.provider
    user.uid = access_token.uid
    unless user.name.present?
      user.name = access_token.info.name
    end
    user.image = access_token.info.image
    user.save
    user.confirmed_at = Time.now #for confirming user
    user
  end

    after_create do
      #assign default role
      self.update(student: true)
    end

    after_touch do
      calculate_student_total
      calculate_teacher_total
      calculate_balance
    end

    monetize :student_total, as: :student_total_cents
    monetize :teacher_total, as: :teacher_total_cents
    monetize :balance, as: :balance_cents

    def to_s
      email
    end

    def to_label
      to_s
    end


  private

    def calculate_student_total
      update_column :student_total, (teacher_total - student_total)
    end

    def calculate_teacher_total
      update_column :teacher_total, lessons.map(&:teacher_price_start).sum
    end

    def calculate_balance
      update_column :balance, attendances.map(&:student_price_start).sum
    end
end
