#!/usr/bin/env ruby

# Copyright 2014 Ingo Renner <ingo@apache.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
#
# A tool to migrate Solr's old stopwords files to json
#
# The old format used until Solr 4.7.x used one word per line.
# Solr 4.8 introduced a REST interface to manage stopwords. The
# REST manager stores the stopwords in a json file.
#
# Usage migratestopwords.rb path/to/solr/core/conf/folder
#

require 'json'

unless ARGV.first
  puts "Requires Solr core configuration folder"
  Process.exit(1)
end

conf_folder = File.absolute_path(ARGV.first)
Dir.glob("**/stopwords.txt") do |stopwords_file_path|
  language = stopwords_file_path.scan(%r|.*/(.*)/.*|).first.first

  stopwords_file = File.open(stopwords_file_path)
  stopwords = stopwords_file.readlines
  stopwords.map! { |word|
    word.sub!(/\|.*$/, "") # strip stopwords file comments
    word.sub!(/#.*$/, "") # strip hash "comments" which are actually invalid
    word.strip!
  }
  stopwords.reject! { |word| word.empty? }

  stopwords_json = JSON.pretty_generate({
    "initArgs"      => {"ignoreCase" => true},
    "initializedOn" => Time.now.strftime("%FT%T.000Z"),
    "managedList"   => stopwords
  })

  managed_file = File.open("#{conf_folder}/_schema_analysis_stopwords_#{language}.json", 'w')
  managed_file.write(stopwords_json)

  managed_file.close
  stopwords_file.close
end










