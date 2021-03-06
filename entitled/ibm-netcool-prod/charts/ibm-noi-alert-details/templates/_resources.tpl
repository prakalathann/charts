{{- define "ibm-noi-alert-details.sizeData" -}}
hpa:
  size0:
    enabled: false
  size1:
    enabled: false
alertdetails:
  size0:
    resources:
      limits:
        memory: 244Mi
        cpu: 300m
      requests:
        memory: 244Mi
        cpu: 100m
  size1:
    resources:
      limits:
        memory: 2000Mi
        cpu: 1000m
      requests:
        memory: 1000Mi
        cpu: 200m
{{- end -}}

{{- define "ibm-noi-alert-details.comp.size.data" -}}
  {{- $root := (index . 0) -}}
  {{- $resName := (index . 1) -}}
  {{- $keyName := (index . 2) -}}
  {{- $sizeData := fromYaml (include "ibm-noi-alert-details.sizeData" .) -}}
  {{- $resData := index $sizeData $resName -}}
  {{- $resSizeData := index $resData $root.Values.global.environmentSize -}}
  {{- $result := index $resSizeData $keyName -}}

  {{- toYaml $result | trimSuffix "\n" -}}
{{- end -}}
