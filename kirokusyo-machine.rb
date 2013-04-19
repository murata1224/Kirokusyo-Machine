#!/usr/bin/ruby
# -*- coding: utf-8 -*-
# % ruby kirokusyo-machine.rb oldrecord_file period1 period2
# % ruby kirokusyo-machine.rb test.org 20130401/20130415 20130415/20130430

require File.expand_path(File.dirname(__FILE__) + '/record_generator.rb')

oldrecord = File.open(ARGV[0])
period1 = ARGV[1]
period2 = ARGV[2]

recordgenerator = RecordGenerator.new
recordgenerator.generate_record(oldrecord, period1, period2)
# org-modeで出力
recordgenerator.output_record
