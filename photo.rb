require File.expand_path('../model_record',__FILE__)
class Photo < ModelRecord
  # require File.expand_path('../race',__FILE__)
  attr_accessor :description, :url, :race_id, :album_id, :id
  belongs_to :race

  #创建表时做对应的数据类型的映射
  def self.table_initial
    create_photo  = <<-SQL
      create table photos(
      id INTEGER PRIMARY KEY,
      description varchar(255),
      url varchar(255),
      race_id INTEGER(11),
      album_id INTEGER(11)
      );
    SQL
    #取得db的路径../data/race.db
    # 创建db
    db = SQLite3::Database.new(DataBase.db_path)
    #执行创建表语句
    db.execute(create_photo)
    db.close
  end

  def initialize(hash={})
    @id = nil
    @description = hash["name"]
    @url = hash["url"]
    @race_id = hash["race_id"]
    @album_id = hash["album_id"]
  end



end