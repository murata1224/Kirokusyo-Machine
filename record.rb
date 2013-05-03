# -*- coding: utf-8 -*-
# 記録書クラス
class Record
  def output_record(user_name, user_laboratory, user_grade, record_number, research_achievements, laboratory_achievements, university_achievements, job_achievements, research_plans, laboratory_plans, university_plans, job_plans)
    @user_name = user_name
    @user_laboratory = user_laboratory
    @user_grade = user_grade
    @record_number = record_number
    output_header
    output_coaching
    output_achievements(research_achievements, laboratory_achievements, university_achievements, job_achievements)
    output_descriptions
    output_plans(research_plans, laboratory_plans, university_plans, job_plans)
    output_other
  end

  def output_header
  end
  
  def output_coaching
  end

  def output_achievements(research_achievements, laboratory_achievements, university_achievements, job_achievements)
  end
  
  def output_descriptions
  end
  
  def output_plans(research_achievements, laboratory_plans, university_plans, job_plans)
  end
  
  def output_other
  end
end

# Org-mode形式の記録書クラス
class RecordOrg < Record

  def output_header
    header = ""
    header << "#+TITLE:     記録書　No.#{@record_number.to_i + 1}\n"
    header << "#+LATEX_HEADER: \\subtitle{(2013年mm月dd日$\\sim$2013年mm月dd日)}\n"
    header << "#+AUTHOR:    #{@user_laboratory}#{@user_grade}\\\\#{@user_name}\n"
    header << "#+DATE:      2013年mm月dd日\n"
    header << "#+SETUPFILE: options/default.org\n"
    print header
  end

  def output_coaching
    coaching = ""
    coaching << "* 前回ミーティングからの指導・指摘事項\n"
    coaching << "  1. xxx\n"
    coaching << "     #+latex: \\newline\n"
    coaching << "     #+latex: \\hfill\n"
    coaching << "     [日にち, 場所，指導・指摘をくださった方]\n\n"
    print coaching
  end

  # 実績
  def  output_achievements(research_achievements, laboratory_achievements, university_achievements, job_achievements)
    print "* 実績\n"
    output_achievements_research(research_achievements)
    output_achievements_laboratory(laboratory_achievements)
    output_achievements_university(university_achievements)
    output_achievements_job(job_achievements)
  end

  # 研究関連
  def output_achievements_research(research_achievements)
    print "** 研究関連\n"
    print_achievements_copied(research_achievements)
  end
  
  # 研究室関連
  def output_achievements_laboratory(schedules)
    print "** 研究室関連\n"
    print_schedules(schedules, "laboratory")
  end
  
  # 大学・大学院関連
  def output_achievements_university(schedules)
    print "** 大学・大学院関連\n"
    print_schedules(schedules, "university")
  end
  
  # 就職活動関連
  def output_achievements_job(schedules)
    print "** 就職活動関連\n"
    print_schedules(schedules, "job")
  end
    
  # 詳細および反省・感想
  def  output_descriptions
    print "* 詳細および反省・感想\n"
    output_descriptions_research
    output_descriptions_laboratory
    output_descriptions_university
    output_descriptions_job
  end

  def output_descriptions_research
    print "** 研究関連\n"
    print_descriptions
  end
  
  # 研究室関連
  def output_descriptions_laboratory
    print "** 研究室関連\n"
    print_descriptions
  end
  
  # 大学・大学院関連
  def output_descriptions_university
    print "** 大学・大学院関連\n"
    print_descriptions
  end
  
  # 就職活動関連
  def output_descriptions_job
    print "** 就職活動関連\n"
    print_descriptions
  end
  
  # 今後の予定
  def  output_plans(research_plans, laboratory_plans, university_plans, job_plans)
    print "* 今後の予定\n"
    output_plans_research(research_plans)
    output_plans_laboratory(laboratory_plans)
    output_plans_university(university_plans)
    output_plans_job(job_plans)
  end

  # 研究関連
  def output_plans_research(research_plans)
    # 前回の記録書からコピーした部分
    
    print "** 研究関連\n"
    print_plans_copied(research_plans)
  end
  
  # 研究室関連
  def output_plans_laboratory(schedules)
    print "** 研究室関連\n"
    print_schedules(schedules)
  end
  
  # 大学・大学院関連
  def output_plans_university(schedules)
    print "** 大学・大学院関連\n"
    print_schedules(schedules)
  end
  
  # 就職活動関連
  def output_plans_job(schedules)
    print "** 就職活動関連\n"
    print_schedules(schedules)
  end

  # その他
  def output_other
    print "* その他\n"
    print "その他書きたいことを書く．"
  end

  #################################
  private
  
  def print_schedules(schedules, type=nil)
    number = 1
    schedules.each do |s|
      if s["date_start"] == s["date_end"]
        print "   " + "#{number}. " + s["summary"] + "\n"
        print "      " + "#+latex: \\hfill" + "\n"
        print "      " + "#+latex: \\label\{enum-#{type}#{number}\}" + "\n"
        print "      " + "(" + s["date_start"] + ")\n"
        number += 1
      end
    end
  end  

  def print_descriptions
    descriptions = ""
    descriptions << "  " +  "#+begin_latex\n"
    descriptions << "  " +  "\\begin{itemize}\n"
    descriptions << "  " +  "\\item[(\\ref{enum:research1})]\n"
    descriptions << "  " +  "\\verb|\\item[]| の中に実績の章で貼ったラベルを参照する．\n"
    descriptions << "  " +  "こうすることで，実績の箇条書きを並べ替えても，詳細および反省・感想のほうに自動で反映される\n"
    descriptions << "  " +  "ここの記述は\\verb|#+begin_latex| ，\\verb|#+end_latex| で囲み，\\LaTeX の記法で記述している．\n"
    descriptions << "  " +  "\\end{itemize}\n"
    descriptions << "  " +  "#+end_latex\n"
    print descriptions    
  end

  def print_achievements_copied(achievements)
    # とりあえずそのまま出力
    achievements.each do |achievement|
      print achievement
    end
    # print_each_line_of_array(achievements,0) # 2は*の数
  end

  def print_plans_copied(plans)
    # 1とりあえずそのまま出力
    plans.each do |plan|
      print plan
    end
    # print_each_line_of_array(plans,0) # 2は*の数
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
  
end
