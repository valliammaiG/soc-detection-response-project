rule Suspicious_Packed_Dropper
{
    meta:
        description = "Flags packed/obfuscated Windows dropper matching campaign payload characteristics (HawkEye-style invoice-phishing malware)"
        author = "Valliammai G"
        date = "2026-08-26"
        reference = "Internal HawkEye Lab investigation"

    strings:
        $mz_header = { 4D 5A 90 00 03 00 00 00 }  // MZ / PE header
        $s1 = "Protected" ascii wide
        $s2 = ".exe" ascii wide

    condition:
        uint16(0) == 0x5A4D and $mz_header at 0 and $s1 and filesize < 2MB
}
