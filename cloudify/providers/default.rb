action :find_hosts do
  ruby_block "find-hosts" do
  block do

    require 'socket'
    require 'timeout'

    # Array to hold host attribute/results
    hostArray = Array.new

    # Possible bug. Sometimes registered_min_hosts is set to 0
    if new_resource.registered_min_hosts == 0
       Chef::Log.warn("registered_min_hosts was set to zero. This is a problem. Setting to 1")
      registered_min_hosts = 1
    end

    Chef::Log.debug("Finding hosts ( clustering_hosts_hp ) registered_min_hosts=#{new_resource.registered_min_hosts}, sleep_time=#{new_resource.sleep_time}, search_type=#{new_resource.search_type}, search_result_type=#{new_resource.search_result_type}, search_param=#{new_resource.search_param}")

    # Loop til minimum # of items are found
    until hostArray.count >= new_resource.registered_min_hosts do

      Chef::Log.info("Sleeping #{new_resource.sleep_time} seconds while waiting for min nodes to register with chef. Min Count = #{new_resource.registered_min_hosts} , Current Count = #{hostArray.count}")
      
      # Reset counter and array
      cnt=0
      hostArray.clear
      
      sleep(new_resource.sleep_time)

      nodes = search(:node, "#{new_resource.search_type}:#{new_resource.search_param}")

      nodes.each do |node|
        Chef::Log.debug("#{node[:hostname]} has IP address #{node[:ipaddress]}")
        begin
          testHost = Timeout::timeout(3) { TCPSocket.open(node[:ipaddress], 22) }
          Chef::Log.debug("#{node[:ipaddress]} verified as alive. Adding #{new_resource.search_result_type} to array")
           # Add found node
           hostArray << node[new_resource.search_result_type]

        rescue Timeout::Error
          Chef::Log.warn("#{node[:ipaddress]} failed TCP check on port 22. Skipping")
        end
    end 
  end
 
  Chef::Log.info("Found #{hostArray.count} nodes") 
  node.override[new_resource.node_attribute_name] = hostArray

  end
  end
end

action :build_etc_hosts do
  ruby_block "build-etc-hosts" do
  block do
    Chef::Log.debug("#{node[new_resource.node_attribute_name]}")
  end
  end
end

