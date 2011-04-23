#
#  SettingsController.rb
#  PowApp
#
#  Created by Thomas Siegfried Krampl on 4/12/11.
#
# TODO: Do something here (Use this class)


class SettingsController
  attr_accessor :pow_bin, :pow_dst_port, :pow_http_port, :pow_dns_port, :pow_timeout, :pow_workers, :pow_domain, :pow_host_root, :pow_log_root, :pow_rvm_path
  attr_accessor :window
  def applicationDidFinishLaunching(a_notification)
    puts "init"
  end
  
  def save_settings(sender)
    
  end
  
  def cancel_settings(sender)
    
  end
  
  private
  def default_settings
    pow_dir = "#{Dir.home}/Library/Application Support/Pow/Current/bin/pow"
    @pow_bin        ||= File.exists?(pow_dir) ? pow_dir : "Couln't find Pow binary"
    @pow_dst_port   ||= 80
    @pow_http_port  ||= 20559
    @pow_dns_port   ||= 20560
    @pow_timeout    ||= 15*60*1000
    @pow_workers    ||= 2
    @pow_domain     ||= "dev"
    @pow_host_root  ||= "#{Dir.home}/Library/Application Support/Pow/Hosts"
    @pow_log_root   ||= "#{Dir.home}/Library/Logs/Pow"
    @pow_rvm_path   ||= "#{Dir.home}/.rvm/scripts/rvm"
  end
end