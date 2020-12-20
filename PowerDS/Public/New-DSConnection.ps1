function New-DSConnection {
    <#
    .SYNOPSIS
        Creates a new DS connection
    .DESCRIPTION
        Creates a new DS connection using user/password or API key
    .EXAMPLE
        New connection using API key
        New-DSConnection -ConnectionName local -DSServerAddress 192.168.1.2 -Port 8080 -APIKey YOURAPIKEY
    .EXAMPLE
        New connection using user and password
        New-DSConnection -ConnectionName local -DSServerAddress 192.168.1.2 -Port 8080 -Credential (get-credential)
    .OUTPUTS
        Digitalstrom Connections of type DSConnection
    #>
    [CmdletBinding(DefaultParameterSetName = 'UserPWD')]
    Param(
        [Parameter(ParameterSetName = 'UserPWD',Mandatory=$True,Position=0)]
        [Parameter(ParameterSetName = 'APIKey',Mandatory=$True,Position=0)]
        [ValidateNotNullOrEmpty()] 
        [string]$ConnectionName,

        [Parameter(ParameterSetName = 'UserPWD',Mandatory=$True,Position=1)]
        [Parameter(ParameterSetName = 'APIKey',Mandatory=$True,Position=1)]
        [ValidateNotNullOrEmpty()] 
        [string]$DSServerAddress,

        [Parameter(ParameterSetName = 'UserPWD',Mandatory=$True,Position=2)]
        [Parameter(ParameterSetName = 'APIKey',Mandatory=$True,Position=2)]
        [ValidateRange(0, 65535)] 
        [int]$Port,

        [Parameter(ParameterSetName = 'UserPWD',Mandatory=$True,Position=3)]
        [PSCredential]$Credential,

        [Parameter(ParameterSetName = 'APIKey',Mandatory=$True,Position=3)]
        [ValidateNotNullOrEmpty()] 
        [string]$APIKey
    )

    if ($Credential) {
        Write-Verbose 'Connection Object with User / Password will be created'
        $EncryptedPassword = $Credential.Password | ConvertFrom-SecureString
        $ConnectionObject = New-Object -TypeName DSConnection -Property @{Name=$ConnectionName;Address=$DSServerAddress;Port=$Port;Username=$Credential.UserName;EncryptedPassword=$EncryptedPassword}
    } elseif ($APIKey) {
        Write-Verbose 'Connection Object with API Key will be created'
        $EncryptedApiKey = $APIKey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
        $ConnectionObject = New-Object -TypeName DSConnection -Property @{Name=$ConnectionName;Address=$DSServerAddress;Port=$Port;EncryptedApiKey=$EncryptedApiKey}
    }
    $ConnectionObject
}