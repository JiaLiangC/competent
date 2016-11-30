require 'sqlite3'
module DataBase  
  DBNAME = "race.sqlite" 

  #class << Database
  #self.before

  # def DataBase.before(*names)
  #   names.each do |method_name|
  #   # 将方法变为自由方法(unbounded method)
  #   m = instance_method(method_name)
  #   # 将方法再次绑定到调用它的对象上
  #   define_method(method_name) do |*args, &block|
  #     # 执行传入before的代码块
  #     yield
  #     #将该方法绑定到调用他的对象，然后执行
  #     m.bind(self).call(*args, &block)
  #   end
  # end

    

    # 在表中插入新的纪录
    def insert_query(table_name, hash = {})
      return  if hash == {}

      fields = []
      values = []
      # 数据库会自动做类型转换
      hash.each do |field_name, value|
       fields << "#{field_name}"
       values << "'#{value}'"
      end
      fields = fields.join(",")
      values = values.join(",")

      query_str = <<-SQL
       INSERT INTO #{table_name}(#{fields})
       VALUES(#{values})
      SQL
      puts query_str
      query_str
    end

    # 更新表中的指定纪录
    def update_query(table_name, id, hash = {})
      return  if hash == {}
      res = hash.map do |field_name, value|
        "#{field_name} = #{value}"
      end
      query_fields = res.join(",")

      query_str = "UPDATE #{table_name} #{query_fields} where id = #{id}"
      puts query_str
      query_str
    end

    def self.where_query(table_name, condition)
      query_str = "SELECT * FROM #{table_name} where #{condition}"
      puts query_str
      query_str
    end

  # end

  # before(*instance_methods) do
  #   # 连接数据库
  #   db = SQLite3::Database.new(db_path)
  #   # 
  # end

  def self.db_path
      File.expand_path("../data/#{DBNAME}", __FILE__)
  end

  def self.db_initial
    # 只执行一次
    # 创建races 表语句
    create_race  = <<-SQL
      create table races(
      id INTEGER PRIMARY KEY,
      name varchar(255),
      start_date varchar(255),
      end_date varchar(255),
      location varchar(255),
      groups varchar(255),
      org_url varchar(255),
      site_url varchar(255)
      );
    SQL
    #取得db的路径../data/race.db
    # 创建db
    db = SQLite3::Database.new(db_path)
    #执行创建表语句
    db.execute(create_race)
    puts create_race
    puts "created successfully"
  end

  # 删除数据库
  def self.db_reset
    File.delete(db_path) if File.exist?(db_path)
    puts "deleted successfully"
  end

end

