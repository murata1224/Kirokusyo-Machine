# -*- coding: utf-8 -*-

class RecordParser
  # 1.実績　の 研究関連を前回の記録書からコピーする．
  # 他の項目はカレンダ情報から作成する．
  # 複数の出力形式に対応するため，各実績を配列で管理する．
  # 今はまだ作れていないため，サンプルデータを返す．
  def get_record_number(record)
    number = 0
    record.readlines.each do |line|
      if line =~ /記録書　No.(\d+)/
        number = $1
        break
      end
    end

    record.rewind
    return number
  end

  def get_research_achievements(record)
    research_achievements = []
    plag = 0
    record.readlines.each do |line|
      if line =~ /\* 実績/
        plag = 1
        next
      end
      if line =~ /\*\* 研究関連/ && plag == 1
        plag = 2
        next
      end
      if line =~ /\*\* 研究室関連/ && plag == 2
        plag = 0
        break
      end
      if plag == 2
        research_achievements << line
      end
    end

    record.rewind
    return research_achievements
  end

  def get_research_plans(record)
    research_plans = []
    plag = 0
    record.readlines.each do |line|
      if line =~ /\* 今後の予定/
        plag = 1
        next
      end
      if line =~ /\*\* 研究関連/ && plag == 1
        plag = 2
        next
      end
      if line =~ /\*\* 研究室関連/ && plag == 2
        plag = 0
        break
      end
      if plag == 2
        research_plans << line
      end
    end

    record.rewind
    return research_plans
  end
end
