#
# Cookbook Name:: wordpress
# Definition:: wordpress_org_plugin
#
# Copyright 2012, Lew Goettner (lew@goettner.net)
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

require 'open-uri'

# Install a plugin from wordpress.org 
define :wordpress_org_plugin, :tag => false do

  # Infer the path from the name unless it's specified
  plugin_path = params[:path] ? params[:path] : params[:name].tr(" ","-").downcase.tr("/","").tr(".","")
  
  # Pull the plugin from the official repository
  base_url = "http://plugins.svn.wordpress.org/#{plugin_path}"
  theme_tag = params[:tag]
  remote_url = ""

  unless params[:tag]
    # Scan the info
    remote_url = "#{base_url}/trunk/readme.txt"
    info_text = open(remote_url) {|f| f.read }
    version = info_text.scan(/^Stable tag: ([a-zA-Z0-9\.]+)/i)
    theme_tag = version[0][0]
  end

  if theme_tag == "trunk"
    remote_url = "#{base_url}/trunk/"
  else 
    remote_url = "#{base_url}/tags/#{theme_tag}"
  end

  subversion params[:name] do
    repository remote_url
    revision 'HEAD'
    destination "#{node['wordpress']['dir']}/wp-content/plugins/#{plugin_path}"
    action :export
    user node['apache']['user']
    group node['apache']['group']
  end

end