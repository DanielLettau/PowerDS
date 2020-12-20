function Get-DSDefaultConfigValue ($ParameterName) {
    $DefaultConfig = Get-DSDefaultConfig
    switch ($ParameterName) {
        "SkipCertificateCheck" {
            if ($DefaultConfig.AlwaysSkipCertificateCheck) {
                return [bool]($DefaultConfig.AlwaysSkipCertificateCheck)
            } else {
                return $null
            }
        }
    }
}