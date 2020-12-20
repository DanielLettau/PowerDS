class DSScene {
    [string]$Name
    [int]$id
    [DSZone]$ParentZone
    [string] ToString() {
        return $this.Name
    }
}