1) - Connect keyclaok to LDAP
    - https://chatgpt.com/c/69f7c5b6-a9e8-83eb-a221-803c01852dd0


# ===========================
# OpenLDAP
# ===========================

# - Conclusion:
    you can setup keycloak federation to sync keycloak users with users in
    openldap by that you can fully controll ldap users via keycloak-operator
    (with its big various of CRD's)

# - Sources

1) - LDAP Operator
    - https://github.com/Symas/openldap-operator
    - https://github.com/digitalis-io/ldap-accounts-controller

    - maybe wrap yourself
    - search for git-ops operator

2) - FreeIPA
    - https://oneuptime.com/blog/post/2026-03-13-deploy-freeipa-identity-management-with-flux-cd/view
    - https://matthewdavidson.us/posts/mealie-k8s-setup/
    - https://github.com/freeipa/freeipa-container/blob/master/tests/freeipa-k8s.yaml

    - search for git-ops operator
