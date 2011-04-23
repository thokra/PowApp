#
#  ApplicationSettingsController.rb
#  PowApp
#
#  Created by Thomas Siegfried Krampl on 4/23/11.
#

class ApplicationSettingsController < NSWindow
  attr_accessor :path, :name, :parent
  
  def windowShouldClose(sender)
    self.orderOut(nil)
  end
  
  def load_application(app)
    @app = app
    @path.stringValue = File.readlink(@app.path)
    @name.stringValue = @app.raw_name
  end
  
  def save_app(sender)
    @app.update_path_name(@name.stringValue)
    windowShouldClose(nil)
    @parent.refresh(nil)
  end
end