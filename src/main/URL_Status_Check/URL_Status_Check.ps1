$ROOT='D:\OneDrive - eClinicalWorks\Scripts\URL_Status_Check\src\main\'
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
    $Output = Invoke-WebRequest -Uri $First -UseBasicParsing 
    $Status = $Output.StatusCode
    $Content = $Output.Content
    $Validation= $Content -match "<status>success</status>"
    ##########################IF LOOP#########################################
    if($Validation -eq "True")
                {
                    $Content="Success"
                }
    else 
            {
                $Content="Failed"
            }






    ##########################################################################

    $RawContentLength = $Output.RawContentLength
    $TimeTaken=(Measure-Command -Expression { $site = $Output}).Milliseconds
	$timestamp= get-date -f yyyy-MM-dd-hh:mm:ss
  
  "$timestamp $First $Status $TimeTaken $RawContentLength $Content" | Out-File $CSV -Encoding ASCII -Append 
  
  Write-Output "$(Get-Date -Format $FORMAT): $First -- $Status -- $TimeTaken ms -- $RawContentLength -- $Content " |Out-File $LOGFILE -Append
  
  } 

Write-Output "$(Get-Date -Format $FORMAT): ######################################################" |Out-File $LOGFILE -Append
Write-Output "$(Get-Date -Format $FORMAT):  Ended" |Out-File $LOGFILE -Append
Write-Output "$(Get-Date -Format $FORMAT): ######################################################" |Out-File $LOGFILE -Append
Write-Host End

