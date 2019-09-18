$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
include RSpec::Matchers
require 'simplecov'

# SimpleCov.minimum_coverage 95
SimpleCov.start

# This module is only used to check the environment is currently a testing env
module SpecHelper
end

require 'fastlane' # to import the Action super class
require 'fastlane/plugin/android_versioning_kts' # import the actual plugin

Fastlane.load_actions # load other actions (in case your plugin calls other actions or shared values)
