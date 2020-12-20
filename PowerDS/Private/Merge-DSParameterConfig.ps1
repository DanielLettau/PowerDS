<#
.SYNOPSIS
    Merges the parameters of a script with the default config values
.DESCRIPTION
    Merges the parameters of a script with the default config values
.EXAMPLE
    Merge-DSParameterConfig -Parameters $PSBoundParameters
#>
function Merge-DSParameterConfig {
    [OutputType('Hashtable')]
    Param (
        # PSBoundParameters of parent Script
        [Parameter(Mandatory=$true,
                   Position=0)]
        $Parameters
    )
    $returnvalues =  @{}

    $ParameterNames = @('SkipCertificateCheck','UseCache')
    
    foreach ($PName in $ParameterNames) {
        $returnvalues.add($PName,'')
        if ($Parameters.keys -contains $PName) {
            $returnvalues.$PName = $Parameters.$PName.IsPresent
        } else {
            $DefaultValue = Get-DSDefaultConfigValue -ParameterName $PName
            if ($null -ne $DefaultValue) {
                $returnvalues.$PName = $DefaultValue
            } else {
                $returnvalues.$PName = $false
            }
        }
        Write-Verbose "$($PName) auf $($returnvalues.$PName) gesetzt"
        if ($PName -eq 'UseCache' -and $returnvalues.$PName -eq $true) {
            Write-Warning 'Using data from cache could return outdated data which might result in errors and strange behaviour'
        }
    }
    return $returnvalues
}