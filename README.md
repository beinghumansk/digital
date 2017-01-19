
Directory "cft_terra_es" have a terraform file which creates a new vpc, igw, route table, subnets,
nacls, security group, 3 instances behind the load balancer.

To install the elastic search application, I have used the anisble, got the roles(java8 and elasticsearch) from ansible-galaxy and applied to the 3 instances.

Configured the elasticsearch cluster, with client, master and nodes servers.

10.0.1.9   es-client-01
10.0.1.26  es-master-01
10.0.1.38  es-node-01

curl http://es-client-01:9200/_cluster/stats
{"timestamp":1484820111790,"cluster_name":"es-dev-cluster","indices":{"count":0,"shards":{},"docs":{"count":0,"deleted":0},"store":{"size_in_bytes":0,"throttle_time_in_millis":0},"fielddata":{"memory_size_in_bytes":0,"evictions":0},"query_cache":{"memory_size_in_bytes":0,"total_count":0,"hit_count":0,"miss_count":0,"cache_size":0,"cache_count":0,"evictions":0},"completion":{"size_in_bytes":0},"segments":{"count":0,"memory_in_bytes":0,"terms_memory_in_bytes":0,"stored_fields_memory_in_bytes":0,"term_vectors_memory_in_bytes":0,"norms_memory_in_bytes":0,"doc_values_memory_in_bytes":0,"index_writer_memory_in_bytes":0,"index_writer_max_memory_in_bytes":0,"version_map_memory_in_bytes":0,"fixed_bit_set_memory_in_bytes":0},"percolate":{"total":0,"time_in_millis":0,"current":0,"memory_size_in_bytes":-1,"memory_size":"-1b","queries":0}},"nodes":{"count":{"total":1,"master_only":0,"data_only":0,"master_data":0,"client":1},"versions":["2.4.4"],"os":{"available_processors":1,"allocated_processors":1,"mem":{"total_in_bytes":580788224},"names":[{"name":"Linux","count":1}]},"process":{"cpu":{"percent":0},"open_file_descriptors":{"min":93,"max":93,"avg":93}},"jvm":{"max_uptime_in_millis":311161,"versions":[{"version":"1.8.0_121","vm_name":"Java HotSpot(TM) 64-Bit Server VM","vm_version":"25.121-b13","vm_vendor":"Oracle Corporation","count":1}],"mem":{"heap_used_in_bytes":41236984,"heap_max_in_bytes":1065025536},"threads":100},"fs":{},"plugins":[]}}

Installed elasticsearch head plugin to view the cluster details in the browser UI
can be reachable at 

http://elasticsearc-eselb-33kbvkf0r4yu-964199574.eu-west-1.elb.amazonaws.com:9200/_plugin/head/

--------------------------------------------------------------------------------------------
Directory "awsmanagedes" - is the AWS managed Elasticsearch:

Using AWS Elasticsearch, there is no need to load balancer as the ES cluster loadbalanced the request. The following links might not work as 
role create for this is specific to my IP. 

Endpoint
    search-beinghumansk-u4e6z6vkwhcj66h65vzxs3xsou.eu-west-1.es.amazonaws.com

Kibana
    search-beinghumansk-u4e6z6vkwhcj66h65vzxs3xsou.eu-west-1.es.amazonaws.com/_plugin/kibana/
    
    
