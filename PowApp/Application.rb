#
#  Application.rb
#  PowApp
#
#  Created by Thomas Siegfried Krampl on 4/14/11.
#

class Application
  def initialize(path, is_app = true)
    if is_app
      @path = path
      find_icon
      generate_name
    else
      @name = path
      default_icon
    end
  end
  
  def path
    @path
  end
  
  def icon
    @icon
  end
  
  def name
    if defined? @name
      @name
    else
      "#{@raw_name}.dev"
    end
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
  
  def open_url
    url = NSURL.URLWithString("http://#{name}/")
    NSWorkspace.sharedWorkspace.openURL(url)
  end
  
  def delete
    File.unlink(path)
  end
  
  private
  def find_icon
    icon_file = [@path, 'public', 'favicon.ico'].join('/')
    if File.exists?(icon_file)
      @icon = NSImage.alloc.initWithContentsOfFile icon_file
    else
      default_icon
    end
  end
  
  def default_icon
    @icon = NSImage.imageNamed 'application'
  end
  
  def generate_name
    @raw_name = @path.split('/').last
  end
end