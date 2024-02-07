# Author: Jacob Lowe
# Description: Dockerfile for Windows Server Core 2019
FROM mcr.microsoft.com/windows/servercore:ltsc2019
# URL for latest version of GIT
ARG GITEXE="Git-2.43.0-64-bit.exe"
ARG GITURL="https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/"
# ENV Variables usable across run commands
ENV GITEXE=${GITEXE}
ENV GITURL=${GITURL}
# Powershell as the shell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Download and install GIT
RUN Invoke-WebRequest -Uri "${env:GITURL}${env:GITEXE}" -OutFile "${env:GITEXE}";
RUN Start-Process -FilePath "${env:GITEXE}" -ArgumentList "/VERYSILENT" -Wait;
RUN Remove-Item -Path "${env:GITEXE}"

# Run the container 
CMD ["powershell", "-Command", "while ($true) { Start-Sleep -Seconds 60 }"]
