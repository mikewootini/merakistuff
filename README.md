# Meraki 



## Q1: Top Swap 

There is no applications using swap on the host so I installed "stress" in order to add things to memory to test the application. Examply run: `` stress -m 4 --vm-bytes 500M``
About 50% done on this, my conclusion is in the status file of the directory.

## Q2: DNS Monitoring

Spent the most time on this, and perhaps got pulled in a little too much making it robust and resilient. I believe it delivers all that is asked. 

## Q3: The Unicorn 

Complete  

1. Which of rack, unicorn and nginx is generating the 400? How can you prove it?  (nginx)
2. Can you narrow down the problem to a specific part of the request?  (proxy redirect is causing the issue)
3. What is the bug that causes the '400 Bad Request' response? How did you find it? How can we fix  
it?  (checking old configs as I've had this problem before.  The proxy forward and redirect was the key) 


Helpful Links I used

https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-unicorn-and-nginx-on-ubuntu-14-04

https://www.cdns.net/DNSSEC-Performance.pdf

https://rimuhosting.com/knowledgebase/linux/misc/checking-your-resolv.conf-file

http://72.249.185.185/fixdns

https://www.golinuxcloud.com/get-script-execution-time-command-bash-script/

https://stackoverflow.com/questions/1092631/get-current-time-in-seconds-since-the-epoch-on-linux-bash


