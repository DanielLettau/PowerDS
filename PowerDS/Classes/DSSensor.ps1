class DSSensor {
    [string]$id
    [int]$value
    [int]$Inputtype
    [string] ToString() {
        return $this.id
    }
}