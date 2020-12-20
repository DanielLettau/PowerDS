class DSUDA {
    [string]$Name
    [int]$id
    [bool]$enabled
    [string] ToString() {
        return $this.Name
    }
}