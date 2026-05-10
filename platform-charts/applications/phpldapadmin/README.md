phpLDAPadmin needs the second thing too: an actual entry it can load after bind.

cat > /tmp/rootdn-entry.ldif <<'EOF'
dn: cn=admin,dc=anykey,dc=pl
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword: admin
EOF

ldapadd -x -H ldapi:/// \
  -D "cn=admin,dc=anykey,dc=pl" \
  -w admin \
  -f /tmp/rootdn-entry.ldif
