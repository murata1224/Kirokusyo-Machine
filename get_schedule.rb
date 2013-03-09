# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/caldav.rb')

##############################################
# カレンダ(url)に登録されている start_date から end_date までの予定を取得する．
# 引数
# url ：String ：カレンダのURL
# user ：String ：カレンダの接続に必要なユーザ名
# pass ：String ：カレンダの接続に必要なパスワード
# start_date ：String ：20130208の形で予定取得の開始年月日を指定
# end_date ：String ：20130209の形で予定取得の終了年月日を指定
# 返り値は予定のリスト．個々の予定はハッシュ{:date_start, :date_end, :summary}
# :date_start　予定の開始日をstringで返す．例："05/21"
# :date_end    予定の終了日をstringで返す．例："05/21"
# :summary     予定のタイトルをstringで返す．例："乃村研ミーティング"
##############################################
def get_schedule (url, user, pass, start_date = nil, end_date = nil)
  initialize_caldav_connection(url, user, pass)
  
  # Googleカレンダーは，time-rangeが使えないのかも．
  uri_xml = get_uri(url, start_date, end_date)
  raise "PROPFIND ERROR (uri_xml is nil)" unless uri_xml
  list_of_uri = get_list_of_uri(uri_xml.body)
  events_xml = get_events(url, list_of_uri)
  list_of_events = 
    get_list_of_events(events_xml.body.force_encoding("utf-8"))
  filter_time_range(list_of_events, start_date, end_date)
end


##########################################
private

def initialize_caldav_connection(url, user, pass)
  @dav = CalDAV.new(url)
  @dav.set_basic_auth(user, pass)
end

# 個々のVEVENTのURIを含むxmlを取得．
def get_uri(url,start_date, end_date)

  xml = <<"EOS"
<D:propfind xmlns:D="DAV:">
<D:prop>
</D:prop>
</D:propfind>
EOS
  @dav.propfind(url, 1, xml)  
end


# xmlを解析し，uriをリストで返す．
def get_list_of_uri(xml)
  xml.scan(/<D:href>(.*?)<\/D:href>/m).flatten
end


# 予定の詳細情報を含むxmlを取得．
def get_events(url, list_of_uri)
  xml = make_xml_for_report(list_of_uri)
  @dav.report(xml, url, 1)
end


# uriのリストを元に，REPORT用のXMLを作成．
def make_xml_for_report(list_of_uri)
  xml = <<"EOS"
<?xml version="1.0" encoding="utf-8" ?>
<C:calendar-multiget xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">
<D:prop>
<D:getetag/>
<C:calendar-data/>
</D:prop>
EOS

  list_of_uri.each do |uri|
    xml += "<D:href>" + uri + "</D:href>\n"
  end if list_of_uri

  xml += "</C:calendar-multiget>"
end


# 予定の詳細情報を含むxmlを解析し，予定の各項目をハッシュとしたリストを返す．
def get_list_of_events(xml)

  # VEVENT毎に切り分け
  vevents = xml.scan(/BEGIN:VEVENT(.*?)END:VEVENT/m).flatten

  list = Array::new

  vevents.map do |vevent|
    list <<  make_hash_of_event(vevent)
  end
  list.sort do |a,b|
    (a["start_year"] <=> b["start_year"]).nonzero? ||
      (a["start_month"] <=> b["start_month"]).nonzero? ||
      a["start_day"] <=> b["start_day"]
  end
end


# 個々のVEVENTから，タイトル，開始月日，および終了月日を抽出
# DATE型でもDATE-TIME型でもいける．
def make_hash_of_event(vevent)
  event = Hash::new

  start_date = vevent.scan(/DTSTART;?.*:(\d{4}?)(\d\d)(\d\d)/).flatten
  event['start_year'] = start_date[0]
  event['start_month'] = start_date[1]
  event['start_day'] = start_date[2]
  end_date = vevent.scan(/DTEND;?.*:(\d{4}?)(\d\d)(\d\d)/).flatten
  event['end_year'] = end_date[0]
  event['end_month'] = end_date[1]
  event['end_day'] = end_date[2]
  summary = vevent.scan(/SUMMARY:(.*)/).flatten
  event['summary'] = summary[0]
  event
end


def filter_time_range(list_of_events, start_date, end_date)
  #start_ymd = start_date.scan(/(\d{4}?)(\d\d)(\d\d)/).flatten
  #end_ymd = end_date.scan(/(\d{4}?)(\d\d)(\d\d)/).flatten

  events_filtered = Array::new

  list_of_events.each do |event|
    if is_event_in_range?(event, start_date, end_date)
#    if is_event_in_range?(event, start_ymd, end_ymd)
      events_filtered << {
        "date_start" => event["start_month"]+"/"+event["start_day"],
        "date_end" => event["end_month"]+"/"+event["end_day"],
        "summary" => event['summary']
      }
    end
  end

  events_filtered
end


def is_event_in_range?(event, s_date, e_date)
  range_start = s_date.to_i
  range_end = e_date.to_i
  
  event_start = 
    (event['start_year'] + event['start_month'] + event['start_day']).to_i
  event_end = 
    (event['end_year'] + event['end_month'] + event['end_day']).to_i

  return true if (event_start >= range_start) && (event_end <= range_end)
  return false
end

################################
