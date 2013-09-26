require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'

CodeSample < Struct.new(:code_text, :eval_to_execute)

