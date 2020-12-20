function Invoke-DSRAWRequest {
    Param(
        [Parameter(Mandatory=$False,Position=0)]
        [string]$URI,
        [Parameter(Mandatory=$False,Position=1)]
        [switch]$SkipCertificateCheck
    )

    if ($PSBoundParameters.keys -notcontains 'SkipCertificateCheck') {
        $SkipCertificateCheck = Get-DSDefaultConfigValue "AlwaysSkipCertificateCheck"
        Write-Verbose "SkipCertificateCheck auf $SkipCertificateCheck gesetzt"
    }
    if (-not $script:DSLastConnection) {
        Write-Error "No Connection to DSS found. Connect first using Connect-DSServer"
    } else {
        try {
            Write-Verbose "Invoking URI $($script:DSBaseUri)$($URI)"
            $Invoke =Invoke-WebRequest -UseBasicParsing -Uri "$($script:DSBaseUri)$($URI)" -WebSession $script:DSSSession -SkipCertificateCheck:$SkipCertificateCheck
        } catch {
            if ($_.ErrorDetails.Message -like "*not logged in*") {
                Write-Warning "DS connection probably timed out. Trying to reconnect..."
                Connect-DSServer -Connection $script:DSLastConnection
                $Invoke =Invoke-WebRequest -UseBasicParsing -Uri "$($script:DSBaseUri)$($URI)" -WebSession $script:DSSSession -SkipCertificateCheck:$SkipCertificateCheck
            } else {
                $_.ErrorDetails.Message
            }
        }
        $varname = "DebugDS_$(get-date -format yyyyMMdd_HHmmss)_$((get-date).Millisecond)"
        Write-Verbose "Writing debug info to variable $varname"
        New-Variable -Name $varname -Value $Invoke -Scope global
        If ($Invoke.Content) {
            $obj = $Invoke | Select-Object -ExpandProperty content | ConvertFrom-Json
            if ($obj.result) {
                $obj | Select-Object -ExpandProperty result
            } elseif ($obj.ok) {
                $obj | Select-Object -ExpandProperty ok
            }
        }
    }
}