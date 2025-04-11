$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'rspec'
require 'data_store'
require 'searcher'
require 'strategies/partial_match'
require 'duplicate_checker'
require 'client_tool'
