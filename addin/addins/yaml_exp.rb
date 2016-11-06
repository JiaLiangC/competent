require  'yaml'
puts "in #{File.basename(__FILE__)} class  #{self.class}"

  addin do
    meta title: "YAML Exporter",
    author: "xiaoliangCai" ,
    version: "v1.0",
    tag: "data/exporter"

    params obj: nil, file_name: "obj.yaml"

    logic do
      puts "Exporting with YAML Exporter ..."
      File.open(params.file_name, "w") do |f|
         f << params.obj.to_yaml
      end
      puts "Data has been exported to #{params.file_name}."
      # something
    end
    
  end