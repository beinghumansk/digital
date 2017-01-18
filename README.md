
Directory "cft_terra_es" have a terraform file which creates a new vpc, igw, route table, subnets,
nacls, security group, 3 instances behind the load balancer.

To install the elastic search application, I have used the anisble, got the roles(java8 and elasticsearch) from ansible-galaxy and applied to the 3 instances.


--------------------------------------------------------------------------------------------
Directory "awsmanagedes" - is the AWS managed Elasticsearch:

Using AWS Elasticsearch, there is no need to load balancer as the ES cluster loadbalanced the request. The following links might not work as 
role create for this is specific to my IP. 

Endpoint
    search-beinghumansk-u4e6z6vkwhcj66h65vzxs3xsou.eu-west-1.es.amazonaws.com

Kibana
    search-beinghumansk-u4e6z6vkwhcj66h65vzxs3xsou.eu-west-1.es.amazonaws.com/_plugin/kibana/
    
    
