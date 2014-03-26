class Check < ActiveRecord::Base

  require 'open-uri'
  require 'pp'

  def check
    start_time = Time.now.to_f
    begin
      uri = URI.parse(self.url)
      web_page = open(uri)  
      pp "#{Time.now}: connection established - OK !" if web_page
    rescue Exception => e
      pp e.inspect
      #pp "#{Time.now}: Connection failed !"
    end
    end_time = Time.now.to_f
    update_rrd(self.rrd_path, Time.now.to_i, ((end_time - start_time)*1000).round)
  end

  def after_destroy
    File.delete(rrd_png)
    File.delete(rrd_path)
  end

  def rrd_png
    "#{RRDImg}/#{self.class.name.downcase}/#{self.id}.png"
  end

  def rrd_png_url
    "rrd/#{self.class.name.downcase}/#{self.id}.png"
  end

  def rrd_path
    "#{RRDPath}/#{self.class.name.downcase}/#{self.id}.rrd"
  end

  def init_rrd(frequency)
    cmd = %{rrdtool create #{self.rrd_path}             \
          --start #{Time.now.to_i}          \
          DS:speed:COUNTER:#{frequency}:U:U   \
          RRA:AVERAGE:0.5:1:288       \
          RRA:AVERAGE:0.5:6:700}

    system cmd
  end

  def update_tune(frequency)
    cmd = %{ rrdtool tune #{self.rrd_path} -h speed:#{frequency} }
    system cmd
  end

  def update_rrd(rrd_path, time, value)
    HardWorker.perform_async(rrd_path, time, value)
  end

end