class DSDevice {
    [string]$Name
    [string]$id
    $object
    [string] ToString() {
        return $this.Name
    }
}