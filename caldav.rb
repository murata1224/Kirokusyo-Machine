# -*- coding: utf-8 -*-
require 'net/https'
require 'uri'

module Net
  class HTTP
    class Report < HTTPRequest
      METHOD = 'REPORT'
      REQUEST_HAS_BODY = true
      RESPONSE_HAS_BODY = true
    end
  end
end

class CalDAV
  
  def initialize(base_url, proxy_host = nil, proxy_port = nil)
    base_url = base_url + '/' unless base_url[base_url.length - 1].chr() == '/'
    uri = URI.parse(base_url)
    @http = Net::HTTP.new(uri.host, uri.port, proxy_host, proxy_port)
    @http.use_ssl = true if uri.scheme == "https"
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @added_headers = Hash::new
  end
  
  def set_basic_auth(user, password)
    @auth_user = user
    @auth_password = password
    return self
  end

  def set_header(name, value)
    @added_headers[name] = value if name && value
  end
  
  def get(path)
    req = setup_request(Net::HTTP::Get, path)
    res = @http.request(req)
    check_status_code(res, 200) # OK
    return res
  end
  
  def post(content, dest_path)
    req = setup_request(Net::HTTP::Post, dest_path)
    req.content_length = content.size
    req.body = content
    res = @http.request(req)
    
    check_status_code(res, [201, 204]) # Created or No content
    return res
  end
  
  def put(content, dest_path)
    req = setup_request(Net::HTTP::Put, dest_path)
    req.content_type = "text/calendar; charset=utf-8"
    req.content_length = content.size
    req.body = content
    res = @http.request(req)
    
    check_status_code(res, [201, 204]) # Created or No content
    return res
  end

  def propfind(path, depth = 1, xml_body = nil)
    req = setup_request(Net::HTTP::Propfind, path)
    req['Depth'] = depth
    
    if xml_body
      req.content_type = 'application/xml; charset="utf-8"'
      req.content_length = xml_body.size
      req.body = xml_body
    end
    res = @http.request(req)
    check_status_code(res, 207) # Multi-Status
    return res
  end

  def delete(path)
    req = setup_request(Net::HTTP::Delete, path)
    res = @http.request(req)
    check_status_code(res, 204)
    return res
  end

  def report(xml, path, depth = 1)
    req = setup_request(Net::HTTP::Report, path)
    req['Depth'] = depth
    req.content_length = xml.size
    req.content_type = 'application/xml; charset="utf-8"'
    req.body = xml
    res = @http.request(req)
    #check_status_code(res, 207)
    return res
  end

  def options(path)
    req = setup_request(Net::HTTP::Options, path)
    res = @http.request(req)
    return res
  end

  ##############################################################
  private

  def check_status_code(res, required_status)
    unless ([required_status].flatten.map{|c| c.to_s}).member?(res.code)
      header = "Invalid HttpResponse Code"
      raise Exception.new("#{header}: #{res.code} #{res.message}")
    end
  end

  def setup_request(request, *args)
    req = request.new(*args)
    req.basic_auth @auth_user, @auth_password
    
    # XXX: should implement re-connection mechanism for Keep-Alive:
    # http://d.hatena.ne.jp/daftbeats/20080321/1206092975
    req["Connection"] = "Keep-Alive"
    if @added_headers
      @added_headers.each do |name,value|
        req[name] = value
      end
    end
    
    return req
  end
  
  def fetch(uri_str, limit = 10)
    raise StandardError, 'HTTP redirect too deep' if limit == 0
    
    response = Net::HTTP.get_response(URI.parse(uri_str))
    case response
    when Net::HTTPSuccess
      response
    when Net::HTTPRedirection
      fetch(response['location'], limit - 1)
    else
      response.value
    end
  end


end  # class WebDav
