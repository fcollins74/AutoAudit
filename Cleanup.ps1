Start-Process -FilePath 'C:\ETCTECH\Audit\Temp\PC Audit\runLocal.bat' /quiet -Wait

$app = Get-WmiObject -Class Win32_Product | Where-Object {
$_.Name -match “Microsoft Baseline Security Analyzer 2.3”
}
$app.Uninstall()

Remove-Item "C:\ETCTECH\Audit\*" -Exclude *.cdf -Recurse