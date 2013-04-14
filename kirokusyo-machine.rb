#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/record_generator.rb')

oldrecord = File.open(ARGV[0])
period1 = ARGV[1]
period2 = ARGV[2]

recordgenerator = RecordGenerator.new
recordgenerator.generate_record(oldrecord, period1, period2)
recordgenerator.output_record

#calendar = Calendar.new
#calendar.set_calendar_data

#record = RecordOrg.new
#record.output_header
#record.output_achevement(calendar)
#record.output_research(research_schedules, achievements)
#record.output_laboratory(laboratory_schedules)
#record.output_university(university_schedules)
#record.output_job(job_schedules)

# org-modeで出力
# output_kirokusyo(research_schedules, achievements)
