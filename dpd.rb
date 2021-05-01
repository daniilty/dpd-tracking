require 'rest-client'
require 'nokogiri'
require 'json'

def load_config(config_file_path)
  cfg = File.readlines(config_file_path)

  return JSON.parse(cfg.join(''))
end

def pretty_gets(decor = '> ')
  print decor

  return gets
end

class Info
  attr_accessor :page
  
  def initialize(tn, url)
    if tn.nil?
      puts "Please gimme your track number"
      return
    end

    doc = RestClient.post(url, { orderNum: tn, orderId: '' })

    @page = Nokogiri::HTML(doc)
  end
  
  def print_track_history
    track_history_entries = @page.xpath("//table[@id='trackHistory']/tr") 

    if track_history_entries.length.zero?
      puts 'Nothing has been found by your tracking number'

      return
    end

    track_history_entries.each do |el|
      puts el.text
    end
  end
end

inf = []

cfg = load_config('config.json')
if cfg["url"].nil? || cfg["tracking_number"].nil?
  inf = pretty_gets('Enter the tracking number and url, separated by comma: ').gsub("\n", '').split(',')
else
  inf.push(cfg["tracking_number"], cfg["url"])
end

inst = Info.new(inf[0], inf[1])

inst.print_track_history
