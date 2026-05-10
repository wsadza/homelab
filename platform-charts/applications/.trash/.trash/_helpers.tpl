{{/* vim: set filetype:mustache: */}}

{{/*
--------------------------------------------
  application - Naming 
--------------------------------------------
*/}}

{{- define "openldap.name" -}}
    {{- default .Chart.Name .Values.openldap.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openldap.fullname" -}}
    {{- include "library.componentFullname" (dict
        "componentName" "openldap"
        "componentValues" .Values.openldap
        "context" $
    ) -}}
{{- end -}}

{{- /*
--------------------------------------------
  application - Namespace 
--------------------------------------------
*/}}

{{- define "openldap.namespace" -}}
  {{- default .Release.Namespace .Values.openldap.namespace | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /*
--------------------------------------------
  application - Labels
--------------------------------------------
*/}}

{{/*
Defines extra labels for optimize.
*/}}
{{- define "openldap.extraLables" -}}
app.kubernetes.io/component: openldap
{{- end -}}

{{/*
Define common labels, combining the match labels and transient labels, which might change on updating
(version depending). These labels should not be used on matchLabels selector, since the selectors are immutable.
*/}}
{{- define "openldap.labels" -}}
{{- template "library.labels" . }}
{{ template "openldap.extraLables" . }}
{{- end -}}

{{/*
--------------------------------------------
  application - Selector labels
--------------------------------------------
*/}}
{{- define "openldap.matchLabels" -}}
{{- template "library.matchLabels" . }}
{{- end -}}

{{/*
--------------------------------------------
  application - Helpers (specyfic)
--------------------------------------------
*/}}

{{/*
Generate replication hosts list for LDAP_REPLICATION_HOSTS
*/}}
{{- define "openldap.replicationHosts" -}}
{{- $replicas := int .Values.openldap.configuration.replication.replicas }}
{{- $namespace := default (include "openldap.namespace" . ) .Values.openldap.namespace }}
{{- $fullname := include "openldap.fullname" . }}
{{- $hosts := list }}
{{- range $i := until $replicas }}
{{- $hosts = append $hosts (printf "ldap://%s-%d.%s-headless.%s.svc.cluster.local" $fullname $i $fullname $namespace) }}
{{- end }}
{{- printf "#PYTHON2BASH:%s" (toJson $hosts) }}
{{- end }}
