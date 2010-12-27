#code=utf-8
# Author: hhuai
# Email: 8863824@gmail.com
# worked on: ubuntu 10.10 + rubymine3.0.1

require 'net/http'
require 'uri'
require 'rexml/document'

include REXML


class ConsoleDict
  def initialize(word)
    @word = word    
  end

  def get_content
    Net::HTTP.get URI.parse('http://dict.cn/ws.php?utf8=true&q='+@word)
  end

  def parser(xml)
    h = {"sent" => []}
    document = Document.new xml
    document.root.each_element do |element|
      value = nil
      if element.name.eql? "sent"
        sent_h = {}
        element.each do |dd|
          sent_h[dd.name] = dd.text
        end
        h[element.name] << sent_h
      else
        h[element.name] = element.text
      end
    end
    h
  end
end

if ARGV.length != 1
  puts "usage: "+File.basename(__FILE__)+" word"
  exit
end
console_dict =  ConsoleDict.new(ARGV[0])
xml = console_dict.get_content
#puts xml
h = console_dict.parser xml
puts h["key"] + " [" + h["pron"] + "]"
puts h["def"]
puts "-"*70

if h["sent"] and h["sent"].is_a? Array
  h["sent"].each do |sent|
    puts sent["orig"].gsub(/<(\/)?em>/,'')
    puts sent["trans"]
  end
end

unless File.exist?("/usr/bin/mocp")
  puts "if you want play audio, must be install moc, like sudo apt-get install moc."
end

mp3_path = "/tmp/"+h["key"]+".mp3"

#change you tool, if you want.
command = "wget -q --no-cookies -O "+mp3_path +" "+h["audio"]+" && mocp -l "+mp3_path
system(command)