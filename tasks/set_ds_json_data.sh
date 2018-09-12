#!/bin/sh
# Puppet Task Name: set_ds_json_data
# To test this and ldap connectivity you can use a public LDAP (http://techsmruti.com/online-ldap-test-server/ for example)
#
# Json Schema
# "schema" : {
#       "help_link" : [ "maybe", "Str" ],
#       "ssl" : "Bool",
#       "(optional-key :ssl_hostname_validation)" : [ "maybe", "Bool" ],
#       "group_name_attr" : "Str",
#       "password" : [ "maybe", "Str" ],
#       "group_rdn" : [ "maybe", "Str" ],
#       "connect_timeout" : [ "maybe", "Int" ],
#       "(optional-key :start_tls)" : [ "maybe", "Bool" ],
#       "user_display_name_attr" : "Str",
#       "hostname" : "Str",
#       "base_dn" : "Str",
#       "user_lookup_attr" : "Str",
#       "port" : "Int",
#       "login" : [ "maybe", "Str" ],
#       "group_lookup_attr" : "Str",
#       "(optional-key :disable_ldap_matching_rule_in_chain)" : [ "maybe", "Bool" ],
#       "group_member_attr" : "Str",
#       "(optional-key :id)" : [ "eq", 1 ],
#       "(optional-key :ssl_wildcard_validation)" : [ "maybe", "Bool" ],
#       "user_email_attr" : "Str",
#       "(optional-key :search_nested_groups)" : [ "maybe", "Bool" ],
#       "user_rdn" : [ "maybe", "Str" ],
#       "group_object_class" : [ "maybe", "Str" ],
#       "display_name" : "Str",
#       "(optional-key :type)" : [ "maybe", [ "enum", "activedirectory", "openldap", "apacheds" ] ]
#     }
# full json data object
# {
#     "base_dn": "ou=mathematicians,dc=example,dc=com", # required
#     "connect_timeout": 30,
#     "disable_ldap_matching_rule_in_chain": true,
#     "display_name": "ldap.forumsys.com", # required
#     "group_lookup_attr": "ou",
#     "group_member_attr": "member",
#     "group_name_attr": "name",
#     "group_object_class": "ou", # required
#     "group_rdn": null, # required
#     "help_link": "http://techsmruti.com/online-ldap-test-server/",
#     "hostname": "ldap.forumsys.com", #required
#     "login": "cn=read-only-admin,dc=example,dc=com",
#     "password": "password",
#     "port": 389, #required
#     "search_nested_groups": true,
#     "ssl": false, #required
#     "ssl_hostname_validation": true,
#     "ssl_wildcard_validation": false,
#     "start_tls": false,
#     "type": null,
#     "user_display_name_attr": "displayName", #required
#     "user_email_attr": "mail",
#     "user_lookup_attr": "uid", "user_rdn": "uid" # required
# }
#
# Minimal data  object
# {
#     "base_dn": "ou=mathematicians,dc=example,dc=com",
#     "display_name": "ldap.forumsys.com",
#     "group_lookup_attr": "ou",
#     "name", "hostname": "ldap.forumsys.com",
#     "port": 389,
#     "ssl": false,
#     "user_display_name_attr": "displayName",
#     "user_email_attr": "mail",
#     "user_lookup_attr": "uid",
#     "user_rdn": "uid"
#     "login" : "cn=read-only-admin,dc=example,dc=com",
#     "password" : "password",
#     "group_rdn" : null,
#     "help_link" : null,
#     "connect_timeout" : null,
#     "group_object_class" : "ou"
# }
#
# example valid json hash as a one line String
# { "base_dn": "ou=mathematicians,dc=example,dc=com", "display_name": "ldap.forumsys.com", "group_lookup_attr": "ou", "group_member_attr": "member", "group_name_attr": "name", "hostname": "ldap.forumsys.com", "port": 389, "ssl": false, "user_display_name_attr": "displayName", "user_email_attr": "mail", "user_lookup_attr": "uid", "user_rdn": "uid", "login" : "cn=read-only-admin,dc=example,dc=com", "password" : "password", "group_rdn" : null, "help_link" : null, "connect_timeout" : null, "group_object_class" : "ou"}
# You can write Puppet tasks in any language you want and it's easy to
# adapt an existing Python, PowerShell, Ruby, etc. script. Learn more at:
# https://puppet.com/docs/bolt/0.x/writing_tasks.html
#
# Learn more at: https://puppet.com/docs/bolt/0.x/writing_tasks.html#ariaid-title11
#

SET_SERVER=$(puppet agent --configprint server)
CONSOLE="${CONSOLE:-$SET_SERVER}"
GET_CERTNAME=$(puppet agent --configprint certname)
if [ $CONSOLE == $GET_CERTNAME ]
then
    curl -X PUT https://${CONSOLE}:4433/rbac-api/v1/ds \
    --cert /etc/puppetlabs/puppet/ssl/certs/${CONSOLE}.pem \
    --key /etc/puppetlabs/puppet/ssl/private_keys/${CONSOLE}.pem \
    --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem -H "Content-Type: application/json" \
    -d "${PT_ds_json}"
else
  echo "This task is only valid to execute on ${SET_SERVER}"
fi
