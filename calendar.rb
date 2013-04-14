# -*- coding: utf-8 -*-
require 'yaml'
require File.expand_path(File.dirname(__FILE__) + '/get_schedule.rb')

class Calendar
  # 前回の記録書，前回ミーティングの日付と，次回ミーティングの日付を調べる．
  # 日付は，"yyyymmdd"の文字列で返す．
  # 今はまだ作れていないため，サンプルデータを返す．
  def initialize(start_date=nil, end_date=nil)
    @start_date = start_date
    @end_date = end_date
  end

  def get_a_period_between_meetings
    return @start_date, @end_date
  end

  def get_calendar_data(type)
    data = YAML.load_file(File.dirname(__FILE__) + '/setting.yml')
    range_start, range_end = get_a_period_between_meetings
    calendar_data = get_schedule(data["#{type}"]["url"], data["#{type}"]["user"], data["#{type}"]["pass"], range_start, range_end)
    return calendar_data
  end

#   def set_calendar_data
#     data = YAML.load_file(File.dirname(__FILE__) + '/setting.yml')
#     range_start, range_end = get_a_period_between_meetings
# # 研究関連のカレンダ
#     @research_schedules =  get_schedule(data["research_calendar"]["url"], data["research_calendar"]["user"],
#                                         data["research_calendar"]["pass"], range_start, range_end)

# # 研究室関連のカレンダ
#     range_start, range_end = get_a_period_between_meetings
#     @laboratory_schedules =  get_schedule(data["laboratory_calendar"]["url"], data["laboratory_calendar"]["user"],
#                           data["laboratory_calendar"]["pass"], range_start, range_end)

#     # 大学・大学院関連のカレンダ
#     range_start, range_end = get_a_period_between_meetings
#     @university_schedules =  get_schedule(data["university_calendar"]["url"], data["university_calendar"]["user"],
#                           data["university_calendar"]["pass"], range_start, range_end)
    
#     # 就職活動関連のカレンダ
#     range_start, range_end = get_a_period_between_meetings
#     @job_schedules =  get_schedule(data["job_calendar"]["url"], data["job_calendar"]["user"],
#                                data["job_calendar"]["pass"], range_start, range_end)
    
#     @achievements = get_achievements
#   end
end
