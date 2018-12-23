#!/bin/bash
#script to run portainer as docker container under https
#counts on the existence of "portainer_data" volume - create it with docker if not created yet

#location of server.crt and server.key
ssl_content_location="/usr/local/portainer_ssl/"
outport=9000
portainer_data_volume_name="portainer_data"

docker run --name=portainer -d -p ${outport}:9000 -v /var/run/docker.sock:/var/run/docker.sock -v $portainer_data_volume_name:/data -v ${ssl_content_location}:/ssl portainer/portainer --ssl --sslcert /ssl/server.crt --sslkey /ssl/server.key

#you will access running portainer instance on eg "https://localhost:9000" from localhost
#or "https://your_server:9000" if remotely
