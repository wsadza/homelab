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


# Add user from LDIF
ldapadd -x -H ldap://0.0.0.0:3890 \
  -D "cn=admin,dc=anykey,dc=pl" \
  -w changeme \
  -f user.ldif
