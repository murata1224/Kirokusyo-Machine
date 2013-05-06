# -*- coding: utf-8 -*-
require 'yaml'
require File.expand_path(File.dirname(__FILE__) + '/calendar.rb')
require File.expand_path(File.dirname(__FILE__) + '/record.rb')
require File.expand_path(File.dirname(__FILE__) + '/record_parser.rb')

# 記録書を生成するクラス
class RecordGenerator 
  attr_accessor :record_number, :research_achievements, :laboratory_achievements, :university_achievements, :job_achievements, :research_plans, :laboratory_plans, :university_plans, :job_plans

  def initialize
    @record = nil
    @record_number = nil
    @user_name = nil
    @user_laboratory = nil
    @user_grade = nil
    @research_achevements = nil
    @laboratory_achievements = nil
    @university_achievements = nil
    @job_achievements = nil
    @research_plans = nil
    @laboratory_plans = nil
    @university_plans = nil
    @job_plans = nil
    @conference_info = nil
  end

  # 記録書を出力
  def output_record
    @record.output_record(@user_name, @user_laboratory, @user_grade, @record_number, @research_achievements, @laboratory_achievements, @university_achievements, @job_achievements, @research_plans, @laboratory_plans, @university_plans, @job_plans, @conference_info)
  end

  # 記録書を生成
  def generate_record(old_record, period1, period2)
    start_date1, end_date1 = period1.split('/')
    start_date2, end_date2 = period2.split('/')
    get_achievemnts(start_date1, end_date1)
    get_plans(start_date2, end_date2)
    parse_record(old_record)
    get_user_info
    @record = RecordOrg.new
  end

  private

  # ユーザ情報(名前，研究室，学年)を取得
  def get_user_info
    data = YAML.load_file(File.dirname(__FILE__) + '/user_info.yml')
    @user_name = data["user_info"]["name"]
    @user_laboratory = data["user_info"]["laboratory"]
    @user_grade = data["user_info"]["grade"]
  end

  # 前回の記録書から，記録書No，研究実績，研究予定を抽出
  def parse_record(record)
    @record_number = get_record_number(record)
    @research_achievements = get_research_achievements(record)
    @research_plans = get_research_plans(record)
    @conference_info = get_conference_info(record)
  end

  # 前回の記録書から，記録書No を抽出
  def get_record_number(record)
    record_parser = RecordParser.new
    record_parser.get_record_number(record)
  end

  # 前回の記録書から，研究実績を抽出
  def get_research_achievements(record)
    record_parser = RecordParser.new
    record_parser.get_research_achievements(record)
  end

  # 前回記録書から，研究予定を抽出
  def get_research_plans(record)
    record_parser = RecordParser.new
    record_parser.get_research_plans(record)
  end

  # 前回記録書から，学会情報を抽出
  def get_conference_info(record)
    record_parser = RecordParser.new
    record_parser.get_conference_info(record)
  end

  # カレンダから，研究室実績，大学関連実績，就職活動関連実績を取得
  def get_achievemnts(start_date, end_date)
    calendar = Calendar.new(start_date, end_date)
    @laboratory_achievements = calendar.get_calendar_data("laboratory_calendar")
    @university_achievements = calendar.get_calendar_data("university_calendar")
    @job_achievements = calendar.get_calendar_data("job_calendar")
  end

  # カレンダから，研究室予定，大学関連予定，就職活動関連予定を取得
  def get_plans(start_date, end_date)
    calendar = Calendar.new(start_date, end_date)    
    @laboratory_plans = calendar.get_calendar_data("laboratory_calendar")
    @university_plans = calendar.get_calendar_data("university_calendar")
    @job_plans = calendar.get_calendar_data("job_calendar")
  end

end
