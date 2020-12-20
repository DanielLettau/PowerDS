class DSZone {
    [string]$Name
    [int]$ID
    [int]$FloorID
    [string] ToString() {
        return $this.Name
    }
}