Description
===========

Installs and configures Wordpress according to the instructions at http://codex.wordpress.org/Installing_WordPress. Does not set up a wordpress blog. You will need to do this manually by going to http://hostname/wp-admin/install.php (this URL may be different if you change the attribute values).

About This Branch
-----------------
I'll try to keep this branch up to date with the latest and greatest. 

Requirements
============

Platform
--------

* Debian, Ubuntu

Tested on:

* Ubuntu 9.04, 9.10, 10.04, 12.04

Cookbooks
---------

* mysql
* php
* apache2
* opensssl (uses library to generate secure passwords)
* subversion

Attributes
==========

* `node['wordpress']['version']` - Set the version to download. Using 'latest' (the default) will install the most current version.
* `node['wordpress']['checksum']` - sha256sum of the tarball, make sure this matches for the version! (Not used for 'latest' version.)
* `node['wordpress']['dir']` - Set the location to place wordpress files. Default is /var/www.
* `node['wordpress']['db']['database']` - Wordpress will use this MySQL database to store its data.
* `node['wordpress']['db']['user']` - Wordpress will connect to MySQL using this user.
* `node['wordpress']['db']['password']` - Password for the Wordpress MySQL user. The default is a randomly generated string.
* `node['wordpress']['server_aliases']` - Array of ServerAliases used in apache vhost. Default is `node['fqdn']`.

Attributes will probably never need to change (these all default to randomly generated strings):

* `node['wordpress']['keys']['auth']`
* `node['wordpress']['keys']['secure_auth']`
* `node['wordpress']['keys']['logged_in']`
* `node['wordpress']['keys']['nonce']`

The random generation is handled with the secure_password method in the openssl cookbook which is a cryptographically secure random generator and not predictable like the random method in the ruby standard library.

If you use the wordpress::org_plugins recipe, it will look for plugins definitions in:

* `node['wordpress']['org_plugins']`

If you user the wordpress:org_themes recipe, it will look for theme definitions in:

* `node['wordpress']['org_themes']`


Usage
=====

If a different version than the default is desired, download that version and get the SHA256 checksum (sha256sum on Linux systems), and set the version and checksum attributes.

Add the "wordpress" recipe to your node's run list or role, or include the recipe in another cookbook.

Chef will install and configure mysql, php, and apache2 according to the instructions at http://codex.wordpress.org/Installing_WordPress. Does not set up a wordpress blog. You will need to do this manually by going to http://hostname/wp-admin/install.php (this URL may be different if you change the attribute values).

The mysql::server recipe needs to come first, and contain an execute resource to install mysql privileges from the grants.sql template in this cookbook.

## Note about MySQL

This cookbook will decouple the mysql::server and be smart about detecting whether to use a local database or find a database server in the environment in a later version.

## Wordpress.org Plugins - Definition and Recipe

This cookbook provides a definition for adding plugins from wordpress.org's plugin directory to your site. My default, just given a name, the defintion will attempt to guess the path to the plugin (on plugins.trac.wordpress.org) by replacing all the spaces with dashes, and removing some punctutation. Additionally, it will pull the latest version of the plugin based off the information provided by the plugin's readme.txt file. However, both the path and tag can be overridden ('trunk' being a special case, and choosing the trunk of the repository over a tag). Here's an example with minimal usage:

    wordpress_org_plugin 'Debug Bar'

And one with the full specificiation:

    wordpress_org_plugin 'Bit.ly Service'
      path  'bitly-service'
      tag   'trunk'
    end

Something like the above might be necessary if a plugin specifies a tag that doesn't actually exist in the plugins.trac.wordpress.org subversion repository, or the name doesn't match up with the subversion path. 

In the case you would like to pass your plugin definitions as node attributes, the wordpress::org_plugins recipe will read the `node['wordpress']['org_plugins']` attribute and apply the definition to each plugin defined. Here's what the following two examples would like like in that case:

    node['wordpress']['org_plugins'] = {
      'Debug Bar' => {},
      'Bit.ly Service' => {
        'path' => 'bitly-service',
        'tag' => 'trunk'
      }
    }

## Wordpress.org Themes - Definition and Recipe

Like the plugin defintion and recipe above, there is also the ability to install themes from the wordpress.org theme repository. The syntax is the same as above, so a simple example would be:

    wordpress_org_theme 'Toolbox'

And a fully specificed example is:

    wordpress_org_theme 'Pagelines' do
      tag '1.1.3'
      path 'pagelines'
    end

Additionally, there is a `wordpress::org_themes` recipe to specify themes via node attributes. Here's the matching example to install the two themes from above:

    node['wordpress']['org_themes'] = {
      'Toolbox' => {},
      'Pagelines' => {
        'path' => 'pagelines',
        'tag' => '1.1.3'
      }
    }

License and Author
==================

Author:: Barry Steinglass (barry@opscode.com)
Author:: Joshua Timberman (joshua@opscode.com)
Author:: Seth Chisamore (schisamo@opscode.com)
Author:: Lew Goettner (lew@goettner.net)

Copyright:: 2010-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
