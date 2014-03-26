RRDPath = File.expand_path('../rrddata', Rails.root)
schedulers_klass = %w{ check }

unless Dir.exists? RRDPath
  Dir.mkdir(File.join(RRDPath), 0777)
end



RRDImg = File.expand_path('./app/assets/images/rrd', Rails.root)
unless Dir.exists? RRDImg
  Dir.mkdir(File.join(RRDImg), 0777)
end

schedulers_klass.each do |klass|
  krrd_path = File.expand_path("./#{klass}", RRDPath)
  unless Dir.exists? krrd_path
    Dir.mkdir(File.join(krrd_path), 0777)
  end

  img_path = File.expand_path("./#{klass}", RRDImg)
  unless Dir.exists? img_path
    Dir.mkdir(File.join(img_path), 0777)
  end
end