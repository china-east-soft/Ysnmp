class Rule < ActiveRecord::Base

  require 'snmp_scheduler'
  require 'open-uri'
  require 'pp'

  validates_uniqueness_of :name
  attr_accessor :_frequency_

  after_create :init_rrd, :create_scheduler

  def before_save
    _frequency_ = self.frequency_changed?
  end

  def after_update
    if _frequency_
      self.update_tune
      self.update_scheduler
    end
  end

  # def rule_scheduler
  #   @rule_scheduler ||= SnmpScheduler.klass_scheduler(self.name.downcase)
  # end

  private

    def create_scheduler
      SnmpScheduler.new(self.name.downcase, self.frequency) do
        self.name.classify.constantize.all.each do |clk|
          clk.check
        end
      end
    end


    def init_rrd
      self.name.classify.constantize.all.each do |clk|
        clk.init_rrd(self.frequency)
      end
    end

    def update_tune
      self.name.classify.constantize.all.each do |clk|
        clk.update_tune(self.frequency)
      end
    end

    def update_scheduler
      rule_scheduler.edit(self.name.downcase, self.frequency) do
        self.name.classify.constantize.all.each do |clk|
          clk.check
        end
      end
    end


end
