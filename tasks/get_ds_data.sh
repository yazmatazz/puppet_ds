#!/bin/sh

# Puppet Task Name:
#
# This is where you put the shell code for your task.
#
# You can write Puppet tasks in any language you want and it's easy to
# adapt an existing Python, PowerShell, Ruby, etc. script. Learn more at:
# https://puppet.com/docs/bolt/0.x/writing_tasks.html
#
# Puppet tasks make it easy for you to enable others to use your script. Tasks
# describe what it does, explains parameters and which are required or optional,
# as well as validates parameter type. For examples, if parameter "instances"
# must be an integer and the optional "datacenter" parameter must be one of
# portland, sydney, belfast or singapore then the .json file
# would include:
#   "parameters": {
#     "instances": {
#       "description": "Number of instances to create",
#       "type": "Integer"
#     },
#     "datacenter": {
#       "description": "Datacenter where instances will be created",
#       "type": "Enum[portland, sydney, belfast, singapore]"
#     }
#   }
# Learn more at: https://puppet.com/docs/bolt/0.x/writing_tasks.html#ariaid-title11
#

SET_SERVER=$(puppet agent --configprint server)
CONSOLE="${CONSOLE:-$SET_SERVER}"
GET_CLIENT=$(puppet agent --configprint clientcert)
if $console == $get_client{
curl -X GET https://${console}:4433/rbac-api/v1/ds \
    --cert /etc/puppetlabs/puppet/ssl/certs/${console}.pem \
    --key /etc/puppetlabs/puppet/ssl/private_keys/${console}.pem \
    --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem -H "Content-Type: application/json" | python -m json.tool
} else {
  echo "This task is only valid to against ${console}"
}
