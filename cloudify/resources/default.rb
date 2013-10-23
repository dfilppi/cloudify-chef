actions :find_hosts, :build_etc_hosts

# Items for :find
attribute :registered_min_hosts, :kind_of => Fixnum, :default => 2 # number of hosts that need to be found before proceeding
attribute :sleep_time, :kind_of => Fixnum, :default => 30 # Seconds to sleep between searching for nodes
attribute :search_type, :kind_of => String,  :default => 'hostname' # chef field to search. ie hostname
attribute :search_result_type, :kind_of => String, :default => 'hostname' # what type of information should be returned. fqdn, hostname etc
attribute :search_param, :kind_of => String, :default => 'should_not_use_the_default' # text to search for
attribute :node_attribute_name, :kind_of => String, :default => 'clustering-hosts-hp-found' # node attribute to put list in or use to build /etc/hosts

