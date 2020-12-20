class DSZone {
    [string]$Name
    [int]$ID
    [int]$FloorID
    [string] ToString() {
        return $this.Name
    }
}
#using module C:\Users\danie\Documents\GitHub\PowerDS\PowerDS\Classes\1_DSZone.ps1
class DSScene {
    [string]$Name
    [int]$id
    [DSZone]$ParentZone
    [string] ToString() {
        return $this.Name
    }
}
class DSConnection {
    [string]$Name
    [string]$Address
    [int]$Port
    [string]$UserName
    [string]$EncryptedPassword
    [string]$EncryptedApiKey
}
class DSDevice {
    [string]$Name
    [string]$id
    $object
}
class DSSensor {
    [string]$Name
    [string]$id
    [int]$value
    [int]$Inputtype
}
class DSUDA {
    [string]$Name
    [int]$id
}
