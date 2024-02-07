FROM mcr.microsoft.com/windows/servercore:ltsc2019
CMD ["powershell", "-Command", "while ($true) { Start-Sleep -Seconds 60 }"]
