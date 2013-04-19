# -*- coding: utf-8 -*-
require 'yaml'
require File.expand_path(File.dirname(__FILE__) + '/get_schedule.rb')

class Calendar
  def initialize(start_date=nil, end_date=nil)
    @calenar = nil
    @start_date = start_date
    @end_date = end_date
  end

  def get_a_period_between_meetings
    return @start_date, @end_date
  end

  # カレンダデータを取得する
  def get_calendar_data(type)
    data = YAML.load_file(File.dirname(__FILE__) + '/setting.yml')
    range_start, range_end = get_a_period_between_meetings
    calendar_data = get_schedule(data["#{type}"]["url"], data["#{type}"]["user"], data["#{type}"]["pass"], range_start, range_end)
    @calendar = calendar_data
    return @calendar
  end

end
