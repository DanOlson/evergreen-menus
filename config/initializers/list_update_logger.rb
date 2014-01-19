logfile = File.open Rails.root.join('log/update_list.log'), 'a+'
ListUpdateLogger = Logger.new logfile

ListUpdateLogger.formatter = proc do |sev, datetime, progname, msg|
  "[List Update: #{datetime}] #{msg}\n"
end
