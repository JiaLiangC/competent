require File.expand_path('../model_record',__FILE__)
class Race < ModelRecord
  # require File.expand_path('../photo',__FILE__)

  has_many :photo

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

# # re
#     def belongs_to(model_name)
#       model_name
#     end
# # article.replies
#     def has_many(model_name)
#       db = SQLite3::Database.new(DataBase.db_path)
#       attributes_arr = db.execute(DataBase.where_query(TABLE_NAME, condition))
#       model_name.where("id = article.id")
#     end

  #race.peple   
end