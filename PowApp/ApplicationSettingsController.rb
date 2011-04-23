#
#  ApplicationSettingsController.rb
#  PowApp
#
#  Created by Thomas Siegfried Krampl on 4/23/11.
#

class ApplicationSettingsController < NSWindowController
  attr_accessor :path, :name
  
  def init
    initWithWindowNibName "ApplicationSettings"
  end
  
  def windowDidLoad
    update_window
  end
  
  def update_window
    @path.stringValue = File.readlink(@app.path)
    @name.stringValue = @app.raw_name
  end
  
  def cancel(sender)
    close
  end
   
  def load_application(app, parent)
    @app = app
    @parent = parent
    showWindow(@parent)
    update_window if windowLoaded?
  end
  
  def save_app(sender)
    @app.update_path_name(@name.stringValue)
    close
    @parent.refresh(nil)
  end
end