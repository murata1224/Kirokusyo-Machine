#!/usr/bin/ruby

require 'yaml'
require File.expand_path(File.dirname(__FILE__) + '/get_schedules.rb')

data = YAML.load_file(File.dirname(__FILE__) + '/setting.yml')
range_start = "20130208"
range_end = "20130301"

print get_schedules(data["calendar"]["url"], data["calendar"]["user"],
                    data["calendar"]["pass"], range_start, range_end)
