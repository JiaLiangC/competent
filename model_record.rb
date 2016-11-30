require File.expand_path('../database',__FILE__)
class ModelRecord
# 
# 自动创建 initialize 方法
# 默认表名是模型名的复数
  def save
    puts DataBase.db_path
    db = SQLite3::Database.new(DataBase.db_path)
    begin
      db.execute(insert_query(self.class.table_name, self.attributes.reject{|k, _| k.to_s == "id"}))
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
      new_race = self.new
      db = SQLite3::Database.new(DataBase.db_path)
      #sql查询后返回的是数组
      attributes_arr = db.execute(DataBase.where_query(table_name, "id = #{id}"))
      db.close
      return if attributes_arr == []
      # 把数组转为一个race 对象
      new_race.set_attributes(attributes_arr[0]) 
      # instance_variables方法返回的属性排序和initialize中属性初始化的顺序一样
      # 所以initialize初始化的顺序要和表中创建列的顺序一样
      # instance_variables中实例变量的排序 和数据库中表的顺序一样
    end

    def where(condition)
      db = SQLite3::Database.new(DataBase.db_path)
      attributes_arr = db.execute(DataBase.where_query(table_name, condition))
      db.close

      return [] if attributes_arr == []

      races = attributes_arr.map do |race_attributes|
        new_race = self.new
        new_race.set_attributes(race_attributes)
      end
      races
    end

    def table_name
      # 约定为模型名的复数
      pluralize(underscore(self.name))
    end

    def underscore(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/').
       gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
       gsub(/([a-z\d])([A-Z])/,'\1_\2').
       tr("-", "_").
       downcase
    end

    def pluralize(str)
      special = {
        "man"=>"men", "woman"=>"women", "policeman"=>"policemen","policewoman"=>"policewomen",
        "mouse"=>"mice", "child"=>"children", "foot"=>"feet", "tooth"=>"teeth", "fish"=>"fish",
        "people"=>"people", "chinese"=>"chinese", "japanese"=>"japanese"
      }
      if special.key?(str)
        special[str]
      elsif  %w(s x).include?(str[-1]) || %(sh ch).include?(str[-2,2])
        str + "es"
      elsif %w(a e i o u).include?(str[-2]) && str[-1] == "y"
        str + "s"
      elsif str[-1] == "y"
        str[0..-2] + "ies"
      elsif str[-1] == "f" || str[-2,2] == "fe"
        str[-1] == "e" ? (str[0..-3] + "ves") : (str[0..-2] + "ves")
      else
        str + "s"
      end   
    end

    def has_many(model_name)
      # :photo 默认传进来的是模型名
      child_table_name = pluralize(model_name.to_s)
      klass_name = model_name.to_s.split("_").map(&:capitalize).join
      foreign_key = underscore(self.name) + "_id"
      # 复数
      define_method(child_table_name) do |*args|
        require(File.expand_path("../#{model_name.to_s}",__FILE__))
        eval(klass_name).where("#{foreign_key} = #{self.id}")
      end
    end

    def belongs_to(model_name)
      klass_name = model_name.to_s.split("_").map(&:capitalize).join
      # 单数
      define_method(model_name) do |*args|
        require(File.expand_path("../#{model_name.to_s}",__FILE__))
        foreign_key = self.instance_variable_get(("@" + model_name.to_s + "_id").to_sym)
        eval(klass_name).where("id = #{foreign_key}")
      end
    end

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



  end
end