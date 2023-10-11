#!/usr/bin/env ruby

require "/data/Master_degree/wae/Labs/web20-02/assignments/config/environment"
 

puts User.count
puts Room.count
c2 = Course.create(course_code:"TC101",course_name:"Theory of computation",school:"SET", offered_year:2020, offered_semester:"August", exam_duration:180)
u2 = User.create(email: "st121077@ait.asia", created_at:Time.now, updated_at:Time.now, is_admin?: false, is_professor?: false, is_user?: true, uid:"st121076", first_name:"test user1", middle_name: nil, last_name:"", is_active?: true, password:"secret")
c2
c2.registers.create(user:u2)

