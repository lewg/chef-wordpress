#
# Cookbook Name:: wordpress
# Definition:: wordpress_svn_plugin
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

# Install a plugin from svn
define :wordpress_svn_plugin, :revision => 'HEAD', :action => :export do

  subversion params[:name] do
    repository params[:repository]
    revision params[:revision]
    destination "#{node['wordpress']['dir']}/wp-content/plugins/#{params[:path]}"
    action params[:action]
  end

end