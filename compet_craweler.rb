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

  # race0_url = sites[0]["race_url"]

  # race_crawler0 = AddinStore.find{ |addin|
  #   addin.meta.title == "Race Crawler0"
  # }.first

  # race_crawler0.params.race_url = race0_url
  # race_crawler0.params.start_id = 723
  # race_crawler0.params.end_id = nil
  # race_crawler0.run


  race1_url = sites[1]["race_url"]

  race_crawler1 = AddinStore.find{ |addin|
    addin.meta.title == "Race Crawler1"
  }.first

  race_crawler1.params.race_url = race1_url
  race_crawler1.params.start_id = 169
  race_crawler1.params.end_id = 5104
  race_crawler1.run


