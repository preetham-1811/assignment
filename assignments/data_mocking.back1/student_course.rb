st121363_c1 = Course.find_by_course_code("AT70.02")
st121363_c2 = Course.find_by_course_code("AT70.12")
st121363_c3 = Course.find_by_course_code("AT71.03")
st121363_c4 = Course.find_by_course_code("AT82.02")

st121363 = User.find_by_email("st121363@ait.asia")

st121363.registers.create(user:st121363_c1)
st121363.registers.create(user:st121363_c2)
st121363.registers.create(user:st121363_c3)
st121363.registers.create(user:st121363_c4)



st121326_c1 = Course.find_by_course_code("AT70.02")
st121326_c2 = Course.find_by_course_code("AT70.03")
st121326_c3 = Course.find_by_course_code("AT70.12")
st121326_c4 = Course.find_by_course_code("AT82.03")

st121326 = User.find_by_email("st121326@ait.asia")

st121326.registers.create(user:st121326_c1)
st121326.registers.create(user:st121326_c2)
st121326.registers.create(user:st121326_c3)
st121326.registers.create(user:st121326_c4)

