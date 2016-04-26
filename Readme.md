

rm -rf hm-cookbooks.tar.gz;  tar cvzf hm-cookbooks.tar.gz . --exclude .git; aws s3 cp hm-cookbooks.tar.gz s3://hm-cookbooks/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers 
