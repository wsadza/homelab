# : Inspirations
#   - https://github.com/vcnngr/helm-openldap/tree/main

# Validate LDAP connectivity
ldapsearch -x -H ldap://0.0.0.0:3890 \
  -b "dc=anykey,dc=pl"

# Create LDIF file (user.ldif)
cat <<EOF > user.ldif
dn: ou=users,dc=anykey,dc=pl
objectClass: organizationalUnit
ou: users

dn: uid=john,ou=users,dc=anykey,dc=pl
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
cn: John Doe
sn: Doe
givenName: John
uid: john
uidNumber: 10001
gidNumber: 10001
homeDirectory: /home/john
loginShell: /bin/bash
mail: john@anykey.pl
userPassword: johnpassword
EOF

# ---------------
CREATE ADMIN USER BEFORE LOGIN TO PHPADMIN
# ---------------

# Add user from LDIF
ldapadd -x -H ldap://0.0.0.0:3890 \
  -D "cn=admin,dc=anykey,dc=pl" \
  -w changeme \
  -f user.ldif

cat > rootdn-entry.ldif <<'EOF'
dn: cn=admin,dc=anykey,dc=pl
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword: admin
EOF

ldapadd -x -H ldaps://openldap.anykey.pl \
  -D "cn=admin,dc=anykey,dc=pl" \
  -w 'admin' \
  -f rootdn-entry.ldif
adding new entry "cn=admin,dc=anykey,dc=pl"


# It supports preseeding via 
