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
  attr_accessor :pages, :track_numbers

  def initialize(tns, url)
    if tns.length.zero?
      puts "Please provide me tracking numbers"

      return
    end
    
    @track_numbers = tns

    @pages = []
    @track_numbers.each do |tn|
      doc = RestClient.post(url, { orderNum: tn, orderId: '' })

      @pages.push(Nokogiri::HTML(doc))
    end
  end
  
  def print_track_history
    @pages.each_with_index do |page, i|
      puts "#{@track_numbers[i]}:"

      track_history_entries = page.xpath("//table[@id='trackHistory']/tr") 

      if track_history_entries.length.zero?
        puts 'Nothing has been found by your tracking number'

        return
      end

      track_history_entries.each do |el|
        puts el.text.gsub("\r", '').split("\n")[1..-2].join(": ")
      end
    end
  end
end

tns = []

cfg = load_config('config.json')
if cfg["tracking_numbers"].length.zero?
  tns = pretty_gets('Enter the tracking numbers, separated by comma: ').gsub("\n", '').split(',')
else
  tns = cfg["tracking_numbers"]
end

inst = Info.new(tns, cfg["url"])

inst.print_track_history
