class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable, :trackable and :omniauthable
  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :registers
  has_many :courses, through: :registers

  validates_presence_of :uid
  validates_uniqueness_of :uid
  # validates_format_of :uid, with: /[a-zA-Z]{2}\d{6}/, message: 'is not in proper format'

  def ldap_before_save
    self.email = Devise::LDAP::Adapter.get_ldap_param(self.uid, 'mail').first
    self.confirmed_at = Time.now
    cn = Devise::LDAP::Adapter.get_ldap_param(self.uid, 'cn').first
    cn_a = cn.split(' ')
    cnl = cn_a.length
    if cnl == 1
      self.first_name = cn
      self.middle_name = ''
      self.last_name = ''
    elsif cnl == 2
      self.first_name = cn_a[0]
      self.middle_name = ''
      self.last_name = cn_a[1]
    else
      self.first_name = cn_a[0]
      self.middle_name = cn_a[1]
      self.last_name = ''
      for i in 2..cnl - 1
        self.last_name = last_name + cn_a[i] + ' '
      end
    end
  end

  def active_for_authentication?
    super && is_active?
  end

  def inactive_message
    is_active? ? super : :locked
  end

  def self.get_users_registered_per_month
    User.find_by_sql("SELECT COUNT(*) as number_of_users_registered, TO_CHAR(created_at, 'Month') AS month from users GROUP BY TO_CHAR(created_at, 'Month') ORDER BY to_date(TO_CHAR(created_at,'Month'),'Month');").map do |row|
      [
          row['month'],
          row.number_of_users_registered.to_i
      ]
    end
  end

  def self.get_users_registered_per_year
    User.find_by_sql("SELECT COUNT(*) as number_of_users_registered, EXTRACT('Year' FROM created_at) AS year from users GROUP BY EXTRACT('Year' FROM created_at)").map do |row|
      [
          row['year'].to_i.to_s,
          row.number_of_users_registered.to_i
      ]
    end
  end

  def self.get_users_per_day_by_month(month = Time.now.month, year = Time.now.year)
    User.find_by_sql(["SELECT COUNT(*) as number_of_users_registered, EXTRACT('Day' FROM created_at) AS day from users WHERE EXTRACT('Month' FROM created_at) = ? AND EXTRACT('YEAR' FROM created_at) = ? GROUP BY EXTRACT('Day' FROM created_at)", month, year]).map do |row|
      [
          row['day'].to_i,
          row.number_of_users_registered.to_i
      ]
    end
  end

end
