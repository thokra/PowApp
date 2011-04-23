#
#  ApplicationController.rb
#  PowApp
#
#  Created by Thomas Siegfried Krampl on 4/12/11.
#

class ApplicationController 
  attr_accessor :btn_add_app, :btn_refresh, :btn_install, :btn_start_stop, :apps_table, :settings_modal, :app_settings_modal
  
  def initialize
    refresh_table
  end
  
  def refresh(sender)
    refresh_table
    @apps_table.reloadData
  end
    
  def add_app(sender)
    @panel = NSOpenPanel.openPanel
    @panel.CanChooseDirectories = true
    @panel.CanChooseFiles = false
    @panel.Prompt = "Add Application"
    @panel.message = "Choose the directory which contains your Rake application"
    if @panel.runModal == NSOKButton
      if File.exists? "#{@panel.filename}/config.ru"
        File.symlink(@panel.filename, "#{Dir.home}/Library/Application Support/Pow/Hosts/#{@panel.filename.split('/').last.gsub(' ', '').downcase}")
        refresh(nil)
      else
        # TODO: Display to the user that there is an error
        puts "Not a rake app"
      end
    end
  end
  
  def refresh_table
    @entries = []
    if Dir.exists? "#{Dir.home}/Library/Application Support/Pow/Hosts"
      Dir.foreach("#{Dir.home}/Library/Application Support/Pow/Hosts") do |file|
        @entries << Application.new("#{Dir.home}/.pow/#{file}") if File.symlink? "#{Dir.home}/.pow/#{file}"
      end
    else
      @entries << "Install Pow to use this system, and click reload"
    end
    @entries
  end
  
  # METHODS FOR THE TABLEVIEW
  def numberOfRowsInTableView(view)
    # Return the number of items.
    @entries.length
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)
    # Return the value at the given row/column position.
    case column.identifier
      when 'icon'
        @entries[index].icon
      when 'name'
        @entries[index].name
      when 'open'
        NSImage.imageNamed 'application-open'
      when 'settings'
        NSImage.imageNamed 'application-settings'
      when 'remove'
        NSImage.imageNamed 'application-remove'
    end
  end
  
  def doubleClickAction(sender)
    return if @apps_table.clickedRow < 0
    case @apps_table.clickedColumn
      when 4
        remove_application(@apps_table.clickedRow)
      when 0, 2
        open_url(@apps_table.clickedRow)
      when 3
        open_settings_modal(@apps_table.clickedRow)
    end
  end
  
  def remove_application(id)
    app = @entries[id]
    File.unlink(app.path)
    refresh nil
  end
  
  def open_settings_modal(id)
    app = @entries[id]
    @app_settings_modal.load_application(app)
    @app_settings_modal.center
    @app_settings_modal.display
    @app_settings_modal.makeKeyAndOrderFront(true)
    @app_settings_modal.orderFrontRegardless
  end
  
  def open_url(id)
    url = NSURL.URLWithString("http://#{@entries[id].name}/")
    NSWorkspace.sharedWorkspace.openURL(url)
  end
  
  def open_pow(sender)
    url = NSURL.URLWithString("http://pow.cx/")
    NSWorkspace.sharedWorkspace.openURL(url)
  end
  
  def settings(sender)
    @settings_modal.center
    @settings_modal.display
    @settings_modal.makeKeyAndOrderFront(nil)
    @settings_modal.orderFrontRegardless
  end
end