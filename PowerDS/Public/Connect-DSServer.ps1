function Connect-DSServer {
    <#
    .SYNOPSIS
        Connects to a Digitalstrom Server
    .DESCRIPTION
        Connects to a Digitalstrom Server. This connection is crutial to every other operation.
    .EXAMPLE
        Connect-DSServer -Connection $connection
    .EXAMPLE
        Connect-DSServer -ConnectionName LocalDSS
    #>
    [CmdletBinding(DefaultParameterSetName = 'ByObject')]
    Param (
        # A connection object. You can get it using Get-DSConnection or New-DSConnection
        [Parameter(ParameterSetName='ByObject',Mandatory=$False,ValueFromPipeline=$True,Position=0)]
        [DSConnection]$Connection,

        # The name of a safed connection
        [Parameter(ParameterSetName='ByName',Mandatory=$False,Position=0)]
        [ArgumentCompleter({Get-ChildItem -Path $DSConfigDir -Filter 'conn*.json' | Foreach-Object {get-content $_ | ConvertFrom-Json | Select-Object -expandproperty Name} | select-object -Unique})]
        [string]$ConnectionName,
        
        # Skips the Certificate check when contacting the Digitalstrom Server
        [Parameter(ParameterSetName='ByObject',Mandatory=$False,Position=1)]
        [Parameter(ParameterSetName='ByName',Mandatory=$False,Position=1)]
        [switch]$SkipCertificateCheck
    )
    Begin {
        $RelevantConfig = Merge-DSParameterConfig -Parameters $PSBoundParameters

        if ($PsCmdlet.ParameterSetName -eq "ByObject" -and $null -eq $Connection) {
            $Connection = New-DSConnection -ConnectionName temp
        }
    }
    Process {
        if ($ConnectionName) {
            try {
                $Connection = Get-DSConnection -Name $ConnectionName
            } catch {
                Write-Error "Could not load connection with name $ConnectionName"
                exit 1
            }
        }
        $script:DSLastConnection = $Connection
        $script:DSBaseUri = "https://$($Connection.Address):$($Connection.Port)/json"

        if ($Connection.EncryptedApiKey) {
            Write-Warning "Sorry. This part is not finished yet. Please use user/password in the meantime"
            exit 1
            $URI = "/system/loginApplication?loginToken=$(ConvertFrom-DsEncryptedString -EncryptedString $Connection.EncryptedAPIKey)"
        } else {
            $URI = "/system/login?user=$($Connection.UserName)&password=$(ConvertFrom-DsEncryptedString -EncryptedString $Connection.EncryptedPassword)"
        }
        $result = Invoke-WebRequest -URI ($script:DSBaseUri + $URI) -SkipCertificateCheck:$RelevantConfig.SkipCertificateCheck -UseBasicParsing -SessionVariable script:DSSSession
        $script:dsstoken = ($result.content | ConvertFrom-Json).result.token
        Write-Verbose "Token: $($script:dsstoken)"
    }
}