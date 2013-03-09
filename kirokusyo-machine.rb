#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'yaml'
require File.expand_path(File.dirname(__FILE__) + '/get_schedule.rb')
require File.expand_path(File.dirname(__FILE__) + '/make_up_kirokusyo.rb')


# 前回の記録書，前回ミーティングの日付と，次回ミーティングの日付を調べる．
# 日付は，"yyyymmdd"の文字列で返す．
# 今はまだ作れていないため，サンプルデータを返す．
def get_a_period_between_meetings
  period_start = "20130225"
  period_end = "20130308"
  return period_start, period_end
end

# 1.実績　の 研究関連を前回の記録書からコピーする．
# 他の項目はカレンダ情報から作成する．
# 複数の出力形式に対応するため，各実績を配列で管理する．
# 今はまだ作れていないため，サンプルデータを返す．
def get_achievements
  achievements = [["研究関連", 
                   ["AAAAAの調査     & (15％，+0％)"], 
                   ["BBBBBの実装     & (100％，+100％)"],
                   ["記録書マシーンの実装", 
                    ["いけてる感じにする       & (0％，0％)"],
                    ["すごい感じにする         & (0％，0％)"]
                   ]
                  ]
                 ]
  return achievements
end


data = YAML.load_file(File.dirname(__FILE__) + '/setting.yml')
range_start, range_end = get_a_period_between_meetings
schedules =  get_schedule(data["calendar"]["url"], data["calendar"]["user"],
                          data["calendar"]["pass"], range_start, range_end)
achievements = get_achievements

# org-modeで出力
output_kirokusyo_to_org(schedules, achievements)

