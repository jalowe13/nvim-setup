# Author: Jacob Lowe
# Description: Dockerfile for Windows Server Core 2019 with .NET Framework 4.8
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019
# Powershell as the shell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Download and install GIT
# URL for latest version of GIT
ARG GITEXE="Git-2.43.0-64-bit.exe"
ARG GITURL="https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/"
# ENV Variables usable across run commands
ENV GITEXE=${GITEXE}
ENV GITURL=${GITURL}
# Download and install GIT
RUN Invoke-WebRequest -Uri "${env:GITURL}${env:GITEXE}" -OutFile "${env:GITEXE}";
RUN Start-Process -FilePath "${env:GITEXE}" -ArgumentList "/VERYSILENT" -Wait;
RUN Remove-Item -Path "${env:GITEXE}"
# Add Paths for NVIM
RUN New-Item -ItemType Directory -Path "C:\\Users\\ContainerAdministrator\\AppData\\Local\\nvim"
ENV nvimPath="C:\\Users\\ContainerAdministrator\\AppData\\Local\\nvim"
# Install Chocolatey
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Run the container 
CMD ["powershell", "-Command", "while ($true) { Start-Sleep -Seconds 60 }"]
