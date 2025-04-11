require_relative './lib/data_store'
require_relative './lib/client_tool'

file_path =  ARGV.shift || 'clients.json'

DataStore.instance.load(file_path)
ClientTool.new.run
