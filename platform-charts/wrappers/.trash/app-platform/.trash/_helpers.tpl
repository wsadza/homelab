{{/* vim: set filetype:mustache: */}}

{{/*
--------------------------------------------
  application - Naming 
--------------------------------------------
*/}}

{{- define "appPlatform.name" -}}
    {{- default .Chart.Name .Values.appPlatform.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "appPlatform.fullname" -}}
    {{- include "library.componentFullname" (dict
        "componentName" "appPlatform"
        "componentValues" .Values.appPlatform
        "context" $
    ) -}}
{{- end -}}

{{- /*
--------------------------------------------
  application - Namespace 
--------------------------------------------
*/}}

{{- define "appPlatform.namespace" -}}
  {{- default .Release.Namespace .Values.appPlatform.namespace | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /*
--------------------------------------------
  application - Labels
--------------------------------------------
*/}}

{{/*
Defines extra labels for optimize.
*/}}
{{- define "appPlatform.extraLables" -}}
app.kubernetes.io/component: appPlatform
{{- end -}}

{{/*
Define common labels, combining the match labels and transient labels, which might change on updating
(version depending). These labels should not be used on matchLabels selector, since the selectors are immutable.
*/}}
{{- define "appPlatform.labels" -}}
{{- template "library.labels" . }}
{{ template "appPlatform.extraLables" . }}
{{- end -}}

{{/*
--------------------------------------------
  application - Selector labels
--------------------------------------------
*/}}
{{- define "appPlatform.matchLabels" -}}
{{- template "library.matchLabels" . }}
{{- end -}}
