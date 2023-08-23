1. Run 'aws configure' on your machine
2. Apply changes to variables.tf regarding instance sizes, RDS user and passwords etc.
3. Run 'terraform apply' and wait for outputs
4. Note 'memchached_endpoint' and 'frontend_loadbalancer_dnsname' values
5. Wait for 'terra-wp-launch' instance to terminate itself
6. Enter the loadbalancer address to browser and setup wordpress
7. Activate 'W3 Total Cache' plugin
8. Go to 'W3 Total Cache' General settings and enable Database cache with Memcached -> SAVE
9. Open 'Advanced' settings for Database cache and enter your 'memchached_endpoint' in hostname field -> click TEST (should be OK) -> click SAVE