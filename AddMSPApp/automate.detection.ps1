$ServerAddress = '##SERVER##'
$LTposh = 'https://dev.azure.com/TechMD/8804336a-dc65-46f8-b0d6-9cb82d919fd2/_apis/git/repositories/c8fbcf7f-1b27-4bca-b3b9-97407c0005eb/items?path=/LabTech.psm1&versionDescriptor[versionOptions]=0&versionDescriptor[versionType]=0&versionDescriptor[version]=main&resolveLfs=true&$format=octetStream&api-version=5.0&download=true'

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(new-object Net.WebClient).DownloadString($LTposh) | iex

Start-Sleep -Seconds 20

$LTServer = (Get-LTServiceInfo).Server
$LastSuccess = (Get-LTServiceInfo).LastSuccessStatus | Get-Date
$90days = (Get-Date).AddDays(-90)
$TimeSpan = New-Timespan -Start $LastSuccess -End $90days

if($LTServer -notcontains $ServerAddress){
    Write-Output 'ERROR: Agent is not healthy'
    exit 1
}elseif($TimeSpan.Days -gt 90){
    Write-Output 'ERROR: Agent is not healthy'
    exit 1
}else{
    Write-Output 'SUCCESS: Agent is healthy'
    exit 0
}
