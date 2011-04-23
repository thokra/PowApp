#
#  ApplicationController.rb
#  PowApp
#
#  Created by Thomas Siegfried Krampl on 4/12/11.
#

class ApplicationController 
  attr_accessor :btn_add_app, :btn_refresh, :btn_install, :btn_start_stop, :apps_table, :settings_modal
  
  def awakeFromNib
    refresh_table
  end
  
  def applicationShouldTerminateAfterLastWindowClosed(a_notification)
    true
  end
  
  def refresh(sender)
    refresh_table
    @apps_table.reloadData
  end
    
  def add_app(sender)
    return unless @installed
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
      @installed = true
      Dir.foreach("#{Dir.home}/Library/Application Support/Pow/Hosts") do |file|
        @entries << Application.new("#{Dir.home}/.pow/#{file}") if File.symlink? "#{Dir.home}/.pow/#{file}"
      end
    else
      @installed = false
      @entries << Application.new("Install Pow to use this system, and click reload", false)
    end
    @entries
  end
  
  # METHODS FOR THE TABLEVIEW
  def numberOfRowsInTableView(view)
    # Return the number of items.
    @entries ? @entries.length : 0
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)
    # Return the value at the given row/column position.
    case column.identifier
      when 'icon'
        @entries[index].icon
      when 'name'
        @entries[index].name
      when 'open'
        NSImage.imageNamed 'application-open' if @installed
      when 'settings'
        NSImage.imageNamed 'application-settings' if @installed
      when 'remove'
        NSImage.imageNamed 'application-remove' if @installed
    end
  end
  
  def doubleClickAction(sender)
    return if @apps_table.clickedRow < 0 or !@installed
    case @apps_table.clickedColumn
      when 4
        @entries[@apps_table.clickedRow].delete
        refresh nil
      when 0, 2
        @entries[@apps_table.clickedRow].open_url
      when 3
        open_settings_modal(@apps_table.clickedRow)
    end
  end
  
  def open_settings_modal(id)
    app = @entries[id]
    @app_settings ||= ApplicationSettingsController.alloc.init
    @app_settings.load_application(app, self)
  end
  
  def open_pow(sender)
    url = NSURL.URLWithString("http://pow.cx/")
    NSWorkspace.sharedWorkspace.openURL(url)
  end
end