require 'ostruct'
ADDINFILE_PATH = File.expand_path('../addins/',__FILE__)

class Addin

  def meta(hash=nil)
    if hash
      @meta = OpenStruct.new(hash)
    else
      @meta
    end
  end

  def params(hash=nil)
    if hash
      @params = OpenStruct.new(hash)
    else
      @params
    end
  end

  def logic(&block)
    @logic = block
  end

  def run
    @logic.call
  end

end


module AddinStore
  @addins = []

  def self.register(addin)
    @addins << addin
  end

  def self.find(&b)
    @addins.select(&b)
  end
end

def addin(&b)
  addin = Addin.new
  addin.instance_eval(&b)
  AddinStore.register(addin)
  addin
end

def load_addins_file(files)
  puts ADDINFILE_PATH
  files.each do |file_name|
    path = File.expand_path("../addins/#{file_name}",__FILE__)
    load path
  end
end

