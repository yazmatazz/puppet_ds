#!/bin/sh
# Puppet Task Name: get_ds_data
#
# This is where you put the shell code for your task.
#
# You can write Puppet tasks in any language you want and it's easy to
# adapt an existing Python, PowerShell, Ruby, etc. script. Learn more at:
# https://puppet.com/docs/bolt/0.x/writing_tasks.html
#
# Learn more at:  https://puppet.com/docs/bolt/0.x/writing_tasks.html#ariaid-title11
#

SET_SERVER=$(puppet agent --configprint server)
CONSOLE="${CONSOLE:-$SET_SERVER}"
GET_CERTNAME=$(puppet agent --configprint certname)
if [ $CONSOLE == $GET_CERTNAME ]
then
    curl -X GET https://${CONSOLE}:4433/rbac-api/v1/ds/test \
    --cert /etc/puppetlabs/puppet/ssl/certs/${CONSOLE}.pem \
    --key /etc/puppetlabs/puppet/ssl/private_keys/${CONSOLE}.pem \
    --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem -H "Content-Type: application/json"
else
  echo "This task is only valid to execute on ${SET_SERVER}"
fi
#
