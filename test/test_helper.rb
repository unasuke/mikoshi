$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aws-sdk'
require 'mikoshi'

require 'minitest/autorun'

Aws.config[:stub_responses] = true
