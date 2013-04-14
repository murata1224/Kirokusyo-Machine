# -*- coding: utf-8 -*
require File.expand_path(File.dirname(__FILE__) + '/calendar.rb')
require File.expand_path(File.dirname(__FILE__) + '/record.rb')
require File.expand_path(File.dirname(__FILE__) + '/record_parser.rb')

class RecordGenerator
 
  attr_accessor :record_number, :research_achievements, :laboratory_achievements, :university_achievements, :job_achievements, :research_plans, :laboratory_plans, :university_plans, :job_plans
  def initialize
    @record = nil
    @record_number = nil
    @research_achevements = nil
    @laboratory_achievements = nil
    @university_achievements = nil
    @job_achievements = nil
    @research_plans = nil
    @laboratory_plans = nil
    @university_plans = nil
    @job_plans = nil
  end

  def output_record
    @record.output_record(@record_number, @research_achievements, @laboratory_achievements, @university_achievements, @job_achievements, @research_plans, @laboratory_plans, @university_plans, @job_plans)
  end

  def generate_record(old_record, period1, period2)
    start_date1, end_date1 = period1.split('/')
    start_date2, end_date2 = period2.split('/')
    get_achievemnts(start_date1, end_date1)
    get_plans(start_date2, end_date2)
    parse_record(old_record)
    @record = RecordOrg.new
  end

  private

  def parse_record(record)
    @record_number = get_record_number(record)
    @research_achievements = get_research_achievements(record)
    @research_plans = get_research_plans(record)
  end

  def get_record_number(record)
    record_parser = RecordParser.new
    record_parser.get_record_number(record)
  end

  def get_research_achievements(record)
    record_parser = RecordParser.new
    record_parser.get_research_achievements(record)
  end

  def get_research_plans(record)
    record_parser = RecordParser.new
    record_parser.get_research_plans(record)
  end

  def get_achievemnts(start_date, end_date)
    calendar = Calendar.new(start_date, end_date)
    @laboratory_achievements = calendar.get_calendar_data("laboratory_calendar")
    @university_achievements = calendar.get_calendar_data("university_calendar")
    @job_achievements = calendar.get_calendar_data("job_calendar")
  end

  def get_plans(start_date, end_date)
    calendar = Calendar.new(start_date, end_date)    
    @laboratory_plans = calendar.get_calendar_data("laboratory_calendar")
    @university_plans = calendar.get_calendar_data("university_calendar")
    @job_plans = calendar.get_calendar_data("job_calendar")
  end

end
