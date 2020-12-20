<#
.SYNOPSIS
    Sets default configuration
.DESCRIPTION
    Sets default configuration for the current user
.EXAMPLE
    Ignores certificate errors of DSS Server connection
    Set-DSDefaultConfig -SkipCertificateCheck
#>

function Set-DSDefaultConfig {
    Param (
        [Parameter(Mandatory=$false,Position=0)]
        [switch]$SkipCertificateCheck
    )

    $config = Get-DSDefaultConfig
    if ($config) {
        foreach ($Parameter in $PSBoundParameters.Keys) {
            if (($config | Get-Member -MemberType NoteProperty).Name -notcontains $Parameter) {
                $config | Add-Member -MemberType NoteProperty -Name $Parameter -Value $null
            }
            if ($PSBoundParameters.$Parameter -is [System.Management.Automation.SwitchParameter]) {
                $config.$Parameter = $PSBoundParameters.$Parameter.IsPresent
            } else {
                $config.$Parameter = $PSBoundParameters.$Parameter
            }
        }
    } else {
        $config = $PSBoundParameters
    }
    $config | ConvertTo-Json | Out-File $DSDefaultConfigFile -Force -Confirm:$false
    Get-DSDefaultConfig
}