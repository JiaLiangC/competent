require 'nokogiri'
require 'net/http'
require 'pry'
require 'pry-nav'
require 'open-uri'
require 'yaml'
require 'sqlite3'
require File.expand_path('../../../race', __FILE__)


  puts "in #{File.basename(__FILE__)} class  #{self.class}"

  addin do
    meta title: "Race Crawler1",
    author: "xiaoliangCai" ,
    version: "v1.0",
    tag: "data/crawler"

    params race_url: nil, start_id: nil, end_id: nil

    logic do
      
      race_url = params.race_url
      start_id = params.start_id
      end_id = params.end_id

      if start_id && end_id
        id_list =(start_id..end_id).to_a
      else
        id_list = []
        id_list << (start_id || end_id)
      end

        id_list.each do |idx| 
          uri = URI(race_url+"id=#{idx}")

          puts "analyzing page #{uri}   ..."

          begin
            res = Net::HTTP.get_response(uri)
            if res.is_a?(Net::HTTPSuccess)
              race = Race.new

              page = Nokogiri::HTML(res.body)
              puts page.css("div.match-title").text.strip.length
              next if page.css("div.match-title").text.strip.length < 15
              race_name = page.css("div.match-title h2.name").text.strip
              start_date = page.css("div.match-title div.date").text.strip.delete("比赛日期：")

              content = page.css("div.match-content p")

              org_web_url  = content.css("p a")[0].children.text

              if content[0].css("span").text.include?("比赛项目")
                groups = content[0].children[1].text.match(/\[(.*?)\]/)[1].split(/、/)
                groups = groups.join(",") 
                puts groups
              end

              if content[2].css("span").text.include?("比赛时间")
                time = content[2].children.text.match(/\[(.*)/).to_s.split(" ")
                race_start_time = time[0]
                race_end_time = time[1]

                puts race_start_time + race_end_time
              end

              if content[3].css("span").text.include?("比赛城市")
                race_location =  content[3].text.match(/\：(.*)/)[1].to_s
                puts race_location
              end

              race.name = race_name
              race.start_date = race_start_time
              race.end_date = race_end_time
              race.location = race_location
              race.groups = groups
              race.org_url = org_web_url
              race.site_url = uri

              race.save

              p race
              puts "\nrequest #{race_url}  successfully"
            else
              puts "request #{race_url}  failed"
            end
          rescue Exception => e
            puts "erros #{e}"
          end
        end
      # end
    end
  end
