class Scheduler
  require 'roo'

  def initialize(num_of_days = 5, num_of_slots = 2, is_excel = true, path = '/Course-202008-CSIM-DSAI.xlsx')
    @path = path
    @Num_of_days = num_of_days
    @Num_of_slots = num_of_slots
    @is_excel = is_excel
    p "is excel is #{@is_excel}"

    if @is_excel == true
      # p "Yo"
      parseExcel()
    else
      #take from database
    end

    buildMatrix
    schedule_alg
    print_schedule

  end

  # p "is excel is #{@is_excel}"

  def parseExcel
    p "Working"
    xlsx = Roo::Spreadsheet.open('public/Course-202008-CSIM-DSAI.xlsx')

    st_co = xlsx.sheets[1]

    xlsx.default_sheet = xlsx.sheets[2]

    @student = []
    @student_course = []
    @course_offered = {}
    @faculty = []
    @course_student = {}

    @courses_offer = []

    xlsx.each_with_pagename do |name, sheet|
      if name == 'Student'
        sheet.each do |s|
          @student.append(s[1..])
        end
      end
      if name == 'student-course'
        sheet.each do |s|
          @student_course.append(s[1..])
          if @course_student.has_key? s[-1]
            @course_student[s[-1]].append(s[1])
          else
            @course_student[s[-1]] = [s[1]]
          end
        end
      end
      if name == 'course offered'
        sheet.each do |s|
          @courses_offer.append(s[1..])
          @course_offered[s[1]] = s[2..]
        end
      end
      if name == 'faculty'
        sheet.each do |s|
          @faculty.append(s[1..])
        end
      end
      # puts name
      # puts sheet.row(1)
    end

    @courses = @course_offered.keys

    @courses.delete 'COURSE_CODE'

    @n_c = @courses.count
    p "nc is #{@n_c}"
  end

  # ===========================================================================
  # Part A - Building the adjacency matrix and graph from the data

  # puts @courses

  def buildMatrix
    @adjacency_matrix = Array.new(@n_c) {Array.new(@n_c, 0)}
    $adjacency_list = Array.new(@n_c) {Array.new}
    @degree = Array.new(@n_c)

    for i in 0..@n_c - 1
      for j in 0..@n_c - 1
        if i!=j
          @adjacency_matrix[i][j] = (@course_student[@courses[i]] & @course_student[@courses[j]]).count
          $adjacency_list[i].append(j) if @adjacency_matrix[i][j] > 0 and not $adjacency_list[i].include? j
        end
      end
      @degree[i] = $adjacency_list[i].count
    end

    tm = @adjacency_matrix.clone
    tl = $adjacency_list.clone
    for i in 0..@n_c - 1
      for j in 0..tl[i].length() - 1
        for k in (j+1)..tl[i].length() - 1
          if tm[i][tl[i][j]] < tm[i][tl[i][k]]
            $adjacency_list[i][j], $adjacency_list[i][k] = $adjacency_list[i][k], $adjacency_list[i][j]
          end
        end
      end
    end
  end

  # # p 'adjacency after'
  # print @adjacency_matrix
  # p '\n'
  # print $adjacency_list
  # p '\n'
  # p @degree
  # p '\n'

  # course_hash = @courses.zip(0..@n_c - 1)
  #
  # @degree_course_hash = @degree.zip(0..@n_c - 1)

  # print @course_student["AT70.03"] & @course_student["AT70.13"]
  # ===================================================================================
  # PART B - Color of the Graph
  #
  def sort_nodes(n_c, degree, adjacency_matrix)
    sorted_c = *(0..n_c - 1)
    for i in 0..n_c - 1
      for j in (i + 1)..n_c - 1
        if degree[sorted_c[i]] < degree[sorted_c[j]]
          sorted_c[j], sorted_c[i] = sorted_c[i], sorted_c[j]
        elsif degree[sorted_c[i]] == degree[sorted_c[j]]
          i_max_weight = adjacency_matrix[sorted_c[i]].max
          j_max_weight = adjacency_matrix[sorted_c[j]].max
          if i_max_weight < j_max_weight
            # p sorted_c
            sorted_c[j], sorted_c[i] = sorted_c[i], sorted_c[j]
            # p sorted_c
          elsif i_max_weight == j_max_weight
            sorted_c[j], sorted_c[i] = sorted_c[i], sorted_c[j] if sorted_c[i] > sorted_c[j]
          end
        end
      end
    end
    return sorted_c
  end


  Num_of_slots = 2
  Num_of_days = 5

  Rs = *(0..(Num_of_days * Num_of_slots)) #Rs are the colors. That is 3 is day 2 and slot 1, 7 is day 4 slot 1 so on for num of slots=2.
  CL = Rs.zip([1] * (Num_of_days * Num_of_slots + 1)).to_h #Concurrency Limit for color rab


  #Internal Distance
  def D1(rij, rik)
    # i, j = (rij+1)/Num_of_slots, rij%Num_of_slots
    # i, k = (rik+1)/Num_of_slots, rik%Num_of_slots

    i, j = getjk(rij)
    i, k = getjk(rik)

    return (k-j).abs + 0.3
  end

  #External Distance
  def D2(rij, rkl)
    # i, j = (rij+1)/Num_of_slots, rij%Num_of_slots
    # k, l = (rkl+1)/Num_of_slots, rkl%Num_of_slots

    i, j = getjk(rij)
    k, l = getjk(rkl)
    return (k-i).abs
  end

  def getjk(rjk)
    j, k = (rjk + 1)/Num_of_slots, rjk%Num_of_slots
    k = Num_of_slots if k==0
    return j, k
  end


  # =========================================
  # Part C - Color the neighbor
  #
  #1
  def getFirstNodeColor(ci)
    for j in 1..Num_of_days
      for k in 1..Num_of_slots
        colorij = (j - 1)*Num_of_slots + k
        return colorij if CL[colorij] >= @CL_c[ci]
      end
    end
    return nil
  end

  #2
  def getSmallestAvailableColor(ci)
    alci = $adjacency_list[ci]
    for j in 1..Num_of_days
      for k in 1..Num_of_slots
        valid = true
        rjk = (j - 1)*Num_of_slots + k
        for r in 0..(alci.length() - 1)
          ref = $color_nodes[alci[r]]
          if ref!= -1
            # e, f = (ref+1)/Num_of_slots, ref%Num_of_slots
            e, f = getjk(ref)
            if e!= j or f!= k
              if D2(ref, rjk) == 0
                if D1(ref, rjk) <= 1
                  valid = false
                  break
                end
              end
              if CL[rjk] <= @CL_c[ci]
                valid = false
                break
              end
              # We are not conducting exams parallely. So, not checking 3 exams constraint
              # if Check3ExamsConstraint(ci, rjk, j) == false
              #   valid = false
              #   break
              # end
            else
              valid = false
              break
            end
          else
            next
          end
        end
        return rjk if valid == true
      end
    end
    return nil
  end


  # ===== Algorithm starts here ===========
  #
  def schedule_alg()
    @SC = sort_nodes(@n_c, @degree, @adjacency_matrix)

    $color_nodes = @SC.zip([-1] * @n_c).to_h

    @CL_c = @SC.zip([0] * @n_c).to_h #Concurrency Level of course

    noOfColoredCourses = 0
    for i in 0..@n_c - 1
      break if noOfColoredCourses == @n_c
      if $color_nodes[@SC[i]] == -1
        if i==0
          rab = getFirstNodeColor(@SC[i])
          if rab == nil
            p "No schedule is possible"
            exit
          end
        else
          rab = getSmallestAvailableColor(@SC[i])
        end
        if rab != nil
          $color_nodes[@SC[i]] = rab
          noOfColoredCourses = noOfColoredCourses + 1
          CL[rab] = CL[rab] - @CL_c[@SC[i]]
        end
      end
      mM = $adjacency_list[@SC[i]]
      for j in 0..(mM.length - 1)
        if $color_nodes[mM[j]] == -1
          if mM[j]==2
          end
          rcd = getSmallestAvailableColor(mM[j])
          if rcd != nil
            $color_nodes[mM[j]] = rcd
            noOfColoredCourses = noOfColoredCourses + 1
            # p "rcd is #{rcd}"
            CL[rcd] = CL[rcd] - @CL_c[mM[j]]
          end
        end
      end
    end
  end

  #3
  # def Scheduler.Check3ExamsConstraint(ci, rjk, j)
  #   j, k = (rjk + 1)/Num_of_slots, (rjk) % Num_of_slots
  #   j, k = getjk(rjk)
  #   counter = 0
  #   for q in 1..Num_of_slots
  #     rjq = (j-1)*Num_of_slots + q
  #     crs = $color_nodes.key(rjq)
  #
  #   end

  # end

  def print_schedule
    p $color_nodes
    p @courses

    # p course_hash.reverse.to_h
    #
    $color_nodes.each do |key, value|
      day, slot = getjk(value)
      p "#{@course_offered[@courses[key]][0]} (#{@courses[key]}) is scheduled on day #{day} and slot number #{slot}"
    end
  end

  def getAll
    return @course_offered, @courses, @student, @student_course, @faculty, @courses_offer, $color_nodes
  end

end
