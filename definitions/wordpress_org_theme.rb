#
# Cookbook Name:: wordpress
# Definition:: wordpress_org_theme
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

# Pull a theme from the wordpress.org site
define :wordpress_org_theme, :tag => false do

  # Infer the path from the name if it's not specified
  theme_path = params[:path] ? params[:path] : params[:name].tr(" ","-").downcase
  
  info_url = "http://wordpress.org/extend/themes/#{theme_path}"
  base_url = "http://themes.svn.wordpress.org/#{theme_path}"
  theme_tag = params[:tag]

  # Scan for the tag if necessary info
  unless params[:tag]
    info_text = open(info_url) {|f| f.read }
    version = info_text.scan(/>Download Version (.+?)<\/a>/)
    theme_tag = version[0][0]
  end

  remote_url = "#{base_url}/#{theme_tag}"

  subversion params[:name] do
    repository remote_url
    revision 'HEAD'
    destination "#{node['wordpress']['dir']}/wp-content/themes/#{theme_path}"
    action :export
    user node['apache']['user']
    group node['apache']['group']
  end

end