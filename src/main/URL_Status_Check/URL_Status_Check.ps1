$ROOT='C:\Users\elex.khedia\Downloads\'
$LOGFILE = $ROOT+'URL_Status_Check\Log\logger.log'
$CSV = $ROOT+'URL_Status_Check\Log\'+'logger.csv'
$FORMAT = 'yyyy-MM-dd-hh:mm:ss'
$FilePath= $ROOT+'URL_Status_Check\URL\url.txt'

[Array] $URLS = Get-Content -Path $FilePath


Write-Host Start 
Write-Output "$(Get-Date -Format $FORMAT): ######################################################" |Out-File $LOGFILE -Append
Write-Output "$(Get-Date -Format $FORMAT):  Started" |Out-File $LOGFILE -Append
Write-Output "$(Get-Date -Format $FORMAT): ######################################################" |Out-File $LOGFILE -Append

"Timestamp URL HTTP_Status TimeTaken_ms RawContentLength Content" | Out-File $CSV -Encoding ASCII -Append
 foreach ($Data in $URLS)
  {
  $Data = $Data -split(',')
  $First = $Data[0]
  $status =  Invoke-WebRequest -Uri $First | % {$_.StatusCode} 
  $content =  Invoke-WebRequest -Uri $First | % {$_.Content} 
  $timeTaken = Measure-Command -Expression {$site = Invoke-WebRequest -Uri $First}
  $milliseconds = $timeTaken.TotalMilliseconds
  $milliseconds = [Math]::Round($milliseconds, 1)
  $RawContentLength = Invoke-WebRequest -Uri $First | % {$_.RawContentLength} 
  $timestamp= get-date -f MM-dd-yyyy_HH_mm_ss
  "$timestamp $First $status $milliseconds $RawContentLength $content" | Out-File $CSV -Encoding ASCII -Append 
  Write-Output "$(Get-Date -Format $FORMAT): $First -- $status -- $milliseconds ms -- $RawContentLength -$content " |Out-File $LOGFILE -Append
  } 

Write-Output "$(Get-Date -Format $FORMAT): ######################################################" |Out-File $LOGFILE -Append
Write-Output "$(Get-Date -Format $FORMAT):  Ended" |Out-File $LOGFILE -Append
Write-Output "$(Get-Date -Format $FORMAT): ######################################################" |Out-File $LOGFILE -Append
Write-Host End
