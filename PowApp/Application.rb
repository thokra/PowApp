#
#  Application.rb
#  PowApp
#
#  Created by Thomas Siegfried Krampl on 4/14/11.
#

class Application
  def initialize(path)
    @path = path
    find_icon
    generate_name
  end
  
  def path
    @path
  end
  
  def icon
    @icon
  end
  
  def name
    "#{@raw_name}.dev"
  end
  
  def raw_name
    @raw_name
  end
  
  def update_path_name(new_name)
    new_path = @path.split('/')
    new_path.pop
    new_path << new_name
    File.rename(@path, new_path.join('/').gsub(' ', '').downcase)
  end
  
  private
  def find_icon
    icon_file = [@path, 'public', 'favicon.ico'].join('/')
    if File.exists?(icon_file)
      @icon = NSImage.alloc.initWithContentsOfFile icon_file
    else
      @icon = NSImage.imageNamed 'application'
    end
  end
  
  def generate_name
    @raw_name = @path.split('/').last
  end
end