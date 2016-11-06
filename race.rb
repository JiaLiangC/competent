require File.expand_path('../database',__FILE__)
class Race 
TABLE_NAME = "races"

  include DataBase

  attr_accessor :name, :start_date, :end_date, :location, :groups, :org_url, :site_url, :id

  def initialize(hash={})
    @id = nil
    @name = hash["name"]
    @start_date = hash["start_date"]
    @end_date = hash["end_date"]
    @location = hash["location"]
    @groups = hash["groups"]
    @org_url = hash["org_url"]
    @site_url = hash["site_url"]
  end

  def save
    puts DataBase.db_path
    db = SQLite3::Database.new(DataBase.db_path)
    begin
      db.execute(insert_query(TABLE_NAME, self.attributes.reject{|k, _| k.to_s == "id"}))
      db.close
    rescue Exception => e
      puts "\n＊＊＊＊＊＊＊＊＊＊save failed , #{e}\n"
    end
  end

  def attributes
    hash = {}
    self.instance_variables.each do |var| 
      hash[var.to_s.delete("@")] = self.instance_variable_get(var)
    end
    puts "empty object" if hash == {}
    hash
  end

  def  set_attributes(attributes_arr)
    self.instance_variables.each_with_index do |var, idx|
      instance_variable_set(var, attributes_arr[idx])
    end
    self
  end

  class << self
    def find(id)
      news = self.new
      db = SQLite3::Database.new(DataBase.db_path)
      #sql查询后返回的是
      attributes_arr = db.execute(news.where_query(TABLE_NAME, "id = #{id}"))
      db.close
      return if attributes_arr == []
      # 把数组转为一个race 对象并且为rowid
      news.set_attributes(attributes_arr[0]) 
      # instance_variables方法返回的属性排序和initialize中属性初始化的顺序一样
      # 所以initialize初始化的顺序要和表中创建列的顺序一样
      # instance_variables中实例变量的排序 和数据库中表的顺序一样
    end
  end

end