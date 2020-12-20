function ConvertFrom-DsEncryptedString {
    Param(
        [Parameter(Mandatory=$True,Position=0)]
        [ValidateNotNullOrEmpty()] 
        [string]$EncryptedString
    )
    $SecureString = $EncryptedString | ConvertTo-SecureString
    $Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($SecureString)
    $result = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr)
    $result
}