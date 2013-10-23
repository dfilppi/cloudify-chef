#
# Cookbook Name:: cloudify
# Recipe:: default
#
# Copyright 2013, GigaSpaces Technologies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# #     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'socket'

public_ip=%x(curl ipecho.net/plain)
private_ip=node[:network][:interfaces][:eth0][:addresses].to_hash.select {|addr, info| info["family"] == "inet"}.flatten.first

cloudify "find-hosts" do
  registered_min_hosts 2
  sleep_time 1
  search_type "tags"
  search_result_type "ipAddress"
  search_param "cloudify-manager"
  node_attribute_name "cloudify-managers"
  action :find_hosts
end

user node[:cloudify][:user] do
  action :create
  system true
  shell "/bin/false"
end

directory node[:cloudify][:workdir] do
  owner "root"
  mode "0755"
  action :create
end

remote_directory "#{node[:cloudify][:workdir]}/upload" do
  owner "root"
  mode "0755"
  source "upload"
  recursive true
end

cookbook_file "#{node[:cloudify][:workdir]}/bootstrap-management.sh" do
	source "bootstrap-management.sh"
	mode 0755
	owner "root"
	group "root"
end

cookbook_file "#{node[:cloudify][:workdir]}/spring-security.xml" do
	source "spring-security.xml"
	mode 0755
	owner "root"
	group "root"
end

template "#{node[:cloudify][:workdir]}/hp-cloud.groovy" do
	source "hp-cloud.groovy"
	mode 0755
	owner "root"
	group "root"
	variables({
		:user => node[:cloudify][:clouduser],
		:tenant => node[:cloudify][:cloudtenant],
		:apikey => node[:cloudify][:apikey],
		:keyfile => node[:cloudify][:keyfile],
		:keypair => node[:cloudify][:keypair],
		:securitygroup => node[:cloudify][:securitygroup],
		:smalllinuxhardwareid => node[:cloudify][:smalllinuxhardwareid],
		:smalllinuximageid => node[:cloudify][:smalllinuximageid],
		:ubuntuimageid => node[:cloudify][:ubuntuimageid],
		:persistencepath => node[:cloudify][:persistencepath]
	})
end

template "#{node[:cloudify][:workdir]}/cloudify_env.sh" do
	source "cloudify_env.sh.erb"
	mode 0666
	owner "root"
	group "root"
	variables({
		:giga_link => node[:cloudify][:link],
		:working_dir => node[:cloudify][:workdir],
		:private_ip => "#{private_ip}",
		:public_ip => "#{public_ip}",
                :locators => "15.185.180.177,15.185.158.164",
		:cloud_file => "#{node[:cloudify][:workdir]}/#{node[:cloudify][:cloudfile]}",
		:spring_security_file => "#{node[:cloudify][:workdir]}/spring-security.xml",
		:cloudify_cloud_machine_id => node[:cloudify][:cloudmachineid],
		:cloudify_cloud_hardware_id => node[:cloudify][:cloudhardwareid],
		:cloudify_cloud_image_id => node[:cloudify][:cloudimageid],
		:giga_cloud_image_id => node[:giga][:cloudimageid],
		:giga_cloud_hardware_id => node[:giga][:cloudhardwareid],
		:giga_cloud_machine_id => node[:giga][:cloudmachineid],
		:giga_cloud_template => node[:giga][:cloudtemplate]
	})
end

bash "bootstrap" do
	cwd "#{node[:cloudify][:workdir]}"
	code <<-EOW
		./bootstrap-management.sh 0 "failed" 4
EOW
end

