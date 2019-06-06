module TaskRankingsHelper
  def masked_student_name(name)
    if name.end_with?("(TA)") then
      return name
    else
      # 直前が [a-zA-Z0-9_] であるような [a-zA-Z0-9_] を '*' に置換
      # eg) test.a.bc => t***.a.b*
      return name.gsub(/(?<=\w)\w/, '*')
    end
  end
end
