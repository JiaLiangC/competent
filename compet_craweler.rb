require 'nokogiri'
require 'net/http'
require 'pry'
require 'pry-nav'
require 'open-uri'
require 'yaml'
# require 'sqlite3'
require File.expand_path('../race', __FILE__)
require File.expand_path('../addin/addin', __FILE__)
require File.expand_path('../addin/addins', __FILE__)

# 第一次扫描1-1000的id，记住有数据的最大的ID，
# 之后扫描时最大的有内容的ID每天增加60个ID
# 


  # # 从yaml配置文件中拉取需要爬取的网站的网址
  def load_sites
    path = File.expand_path("../data/sites.yaml",__FILE__)
    YAML.load_file(path)
  end

  sites = load_sites
  race_url = sites[0]["race_url"]

  race_crawler = AddinStore.find{ |addin|
    addin.meta.title == "Race Crawler1"
  }.first

  race_crawler.params.race_url = race_url
  race_crawler.params.start_id = 723
  race_crawler.params.end_id = nil

  race_crawler.run


  # end
# end
