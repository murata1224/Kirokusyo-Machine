# -*- coding: utf-8 -*-
def output_kirokusyo_to_org(schedules, achievements)
  print "** 前回ミーティングでの指導・指摘事項\n"
  print "** 実績\n"

  # 前回の記録書からコピーした部分
  print_achievements_copied(achievements)

  print "*** 研究関連\n"
  schedules.each do |s|
    if s["date_start"] == s["date_end"]
      print s["summary"] + "   " + "(" + s["date_start"] + ")\n"
    end
  end
end


#################################
private

def print_achievements_copied(achievements)
  print_each_line_of_array(achievements,2) # 2は*の数
end

def print_each_line_of_array(ary,depth)
  return nil unless ary.instance_of?(Array)
  
  ary.each do |a|
    if a.instance_of?(Array)
      print_each_line_of_array(a,depth+1) 
    else
      depth.times { print "*" }
      print " " + a + "\n"
    end
  end
end
