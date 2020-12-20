class DSConnection {
    [string]$Name
    [string]$Address
    [int]$Port
    [string]$UserName
    [string]$EncryptedPassword
    [string]$EncryptedApiKey
    [string] ToString() {
        return $this.Name
    }
}