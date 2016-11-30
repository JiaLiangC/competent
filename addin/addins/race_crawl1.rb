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
          uri = URI(race_url+"#{idx}")

          puts "analyzing page #{uri}   ..."

          begin

            res = Net::HTTP.get_response(uri)
            if res.is_a?(Net::HTTPSuccess)
              race = Race.new
              
              page = Nokogiri::HTML(res.body)
              race_info = page.css("div.deal_details_head")

              race_name = race_info.css("div[rel='right'] h1").text
              race_info.css("div[rel='content'] p")[0].text

              time_info = race_info.css("div[rel='content'] p")[0].text.delete("时间：")
              year = time_info.split("年")[0]
              tmp_time = race_info.css("div[rel='content'] p")[0].text.delete("时间：").split("—")
              race_start_time = tmp_time[0]
              race_end_time = year+tmp_time[1]

              race_location = race_info.css("div[rel='content'] p")[1].text.delete("地点：")

              groups = race_info.css("div[rel='content'] p")[2].children.last.text.split("、").join(",")

              race.name = race_name
              race.start_date = race_start_time
              race.end_date = race_end_time
              race.location = race_location
              race.groups = groups
              race.org_url = nil
              race.site_url = uri

              # 已存在的比赛不存入数据库
              next if  Race.where("name='#{name}'") != []

              race.save
              p race
              puts "\nrequest #{uri}  successfully"
            end
          rescue Exception => e
            puts "erros #{e}"
          end
        end
      # end
    end
  end
