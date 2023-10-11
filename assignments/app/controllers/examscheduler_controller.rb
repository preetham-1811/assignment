require_relative 'scheduler'

class ExamschedulerController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, except: [:index, :full_schedule]

  def index
    # @schedules = Schedule.all
    # puts @schedules

    @schedules = []
    current_user.courses.each do |c|
      @schedules.append(Schedule.find_by_course_id(c.id))
    end
    puts @schedules
  end

  def admin
  end

  def manage_users
  end

  def recently_registered_users
    @users = User.where(is_admin?: false).order('created_at DESC').limit(5)
  end

  def ban_users
    @users = User.where(is_admin?: false).order('id')

    if params[:id]
      @bann = User.where(id: params[:id])[0]
      if @bann.is_active?
        @bann.update(is_active?: false)
      else
        @bann.update(is_active?: true)
      end
      @bann.save
    end
  end

  def view_stats
    @user_per_month = User.get_users_registered_per_month

    @user_per_day = if params.has_key?(:date)
      # print params
                      User.get_users_per_day_by_month(params[:date][:register_month], params[:date][:register_year])
                    else
                      User.get_users_per_day_by_month
                    end

    @user_per_year = User.get_users_registered_per_year
  end

  def parseSchedule
    # print "parameters are #{params}"
    @a = params[:dates]
    @s = Scheduler.new()
    @course_offered, @courses, @student, @student_course, @faculty, @courses_offer, @color_nodes = @s.getAll
    p "Courses offered are #{@course_offered}"
    p "Courses are #{@courses}"
    p @faculty

    (0..@courses.length - 1).each do |i|
      c = @course_offered[@courses[i]]
      next if Course.find_by_course_code(c)

      cou = Course.create(course_code: @courses[i], course_name: c[0], school: 'SET', offered_year: c[1],
                          offered_semester: c[2], exam_duration: 3, is_active: true)
    end

    (1..@faculty.length - 1).each do |i|
      p "Faculty is #{@faculty[i]}"
      u = User.find_by_first_name(@faculty[i][1])
      next if u

      u = User.new(uid: @faculty[i][0], email: @faculty[i][0] + '@ait.asia', password: 'dragon',
                   first_name: @faculty[i][1], middle_name: @faculty[i][2], last_name: @faculty[i][3],
                   'is_professor?': true, 'is_user?': false, confirmed_at: Time.now)
      # u.id = @faculty[i][0]
      u.save
    end

    (1..@student.length - 1).each do |i|
      u = User.find_by_uid('st' + @student[i][0])
      next if u

      u = User.create(uid: 'st' + @student[i][0], email: 'st' + @student[i][0] + '@ait.asia', password: 'dragon',
                      first_name: @student[i][1], middle_name: @student[i][2], last_name: @student[i][3],
                      confirmed_at: Time.now)
    end

    Register.delete_all
    (1..@student_course.length - 1).each do |i|
      sc = Register.create(course: Course.find_by_course_code(@student_course[i][3]),
                           user: User.find_by_uid('st' + @student_course[i][0]))
    end

    (1..@courses_offer.length - 1).each do |i|
      pc = Register.create(course: Course.find_by_course_code(@courses_offer[i][0]),
                           user: User.find_by_uid(@courses_offer[i][4]))
    end

    Schedule.delete_all
    i = 1
    @color_nodes.each do |key, value|
      r = if i.even?
            1
          else
            2
          end
      c = if i.even?
            'Do well'
          else
            'Give ur best'
          end
      day = (value + 1) / 2 # Taking No of slots=2
      slot = value % 2
      slot = 2 if slot.zero?
      if slot == 1
        st = DateTime.parse(@a[day - 1]) + 9.hours
        et = DateTime.parse(@a[day - 1]) + 12.hours
      else
        st = DateTime.parse(@a[day - 1]) + 13.hours
        et = DateTime.parse(@a[day - 1]) + 16.hours
      end
      scd = Schedule.create(course: Course.find_by_course_code(@courses[key]), room: Room.find(r), comment: c,
                            start_time: st, end_time: et)
      i += 1
    end

    p "check: #{@a[0]}"
    render layout: nil
  end

  def full_schedule
    @schedules = Schedule.all
    puts @schedules
  end

  private

  def check_admin
    return unless !current_user.is_admin?

    redirect_to request.referrer || examscheduler_index_path, alert: 'Admins only!'
  end

end
