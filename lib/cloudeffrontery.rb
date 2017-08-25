require 'net/https'
require 'uri'
require 'json'
require 'ipaddr'

class Cloudeffrontery

  attr_accessor :debug
  attr_accessor :region
  attr_accessor :service
  attr_accessor :awsurl
  attr_accessor :azureurl
  attr_accessor :cloud

  def initialize
    @awsurl = "https://ip-ranges.amazonaws.com/ip-ranges.json"
    @azureurl = "https://www.cloudflare.com/ips-v4"
    @service = 'CLOUDFRONT'
    @region = '.*'
    @cloud = 'aws'
    @debug = false
  end

  def print
    $stdout.puts retrieve.inspect
  end

  def url
    if @url
      debug("Returning custom URL #{@url}")
      returnurl = @url
    else
      debug("Returning URL for #{@cloud}")
      returnurl = @cloud == 'aws' ? @awsurl : @azureurl
    end
    return returnurl
  end

  def url=(value)
    debug("Setting URL to #{value}")
    @url = value
  end

  def retrieve 
    method="retrieve#{@cloud}".to_sym
    self.send(method)
  end

  def retrieveazure
    theurl = url
    begin
      uri = URI.parse(theurl)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https' ? true : false
      request = Net::HTTP::Get.new(uri.request_uri)
      thejson = http.request(request)
    rescue
      return nil
    end
  
    if thejson.kind_of? Net::HTTPSuccess
      return thejson.body.split("\n").select { |r| IPAddr.new(r) rescue nil }
    else
      return nil
    end

  end

  def debug(message)
    $stdout.puts "#{Time.now}: #{message}" if @debug
  end

  def retrieveaws
    theurl = url
    debug("Getting some Amazon ranges using #{theurl}")
    begin
      uri = URI.parse(theurl)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https' ? true : false
      request = Net::HTTP::Get.new(uri.request_uri)
      thejson = http.request(request)
    rescue => e
      debug("Failed to be getting some Amazon ranges - #{e.inspect}")
      return nil
    end
  
    if thejson.kind_of? Net::HTTPSuccess
      return filter(JSON::parse(thejson.body))
    else
      return nil
    end
  
  end

  def nginx
    return_config = []
    ranges = retrieve
    debug("We got #{ranges.size} ranges")
    ranges.each do |r|
      return_config.push "set_real_ip_from #{r.strip};"
    end
    return_config.join("\n")
  end

  def apache
    return_config = []
    ranges = retrieve

    return_config.push "# Cloudfront public IPs for #{@region} and #{@service}"
    ranges.each do |r|
      return_config.push "#{r.strip}"
    end
    return_config.join("\n")
  end

  def filter(ranges)

    unless ranges.is_a?(Hash)
      return nil
    end    
  
    returnranges = ranges['prefixes'].select { |r| r['region'].match(/#{@region}/) && r['service'] == @service }.map { |r| r['ip_prefix'] }.select { |r| IPAddr.new(r) rescue nil }
    returnranges

  end

end
