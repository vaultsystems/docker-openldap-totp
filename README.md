OpenLDAP 2.5 (master) with OATH TOTP on Alpine Linux

    docker run -d -p 389 -p 636 -v slapd.conf:/etc/openldap/slapd.conf -v var:/var/openldap-data docker-openldap-totp

Modified for Feitian c200 TOTP tokens with 60s token expiry.

Convert 20 byte (40 hex) TOTP seed to base32 in python:

    import base64
    base64.b32encode("4D5449304E545A42516B4E454E7A67355957494B".decode('hex'))

Alternatively, put hex seed into a file and convert to ascii (need to install 'vim' on alpine):

    xxd -r -p test.hex > test.str

Then load password into LDAP and test:

   ldappasswd -D cn=Manager,dc=company,dc=com,dc=au -T test.str -W -H ldap://localhost "cn=username,ou=users,dc=company,dc=com,dc=au"
   ldapwhoami -D "cn=username,ou=users,dc=company,dc=com,dc=au" -W
