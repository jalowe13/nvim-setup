# Jacob Lowe
# My LazyVim IDE setup

# Check if Docker is installed on the current computer
#

try {
    docker version
    Write-Host "Docker is installed and running."
  } catch {
      # Grab info on current processor for docker install
      $cpuname = (Get-WmiObject Win32_Processor).Name
      Write-Host "Docker is not installed or running. Installing and running."
      Write-Host "After installing Docker, please restart your computer and run the script again."
      # Install Docker
      if ($cpuname -match "AMD"){
        $url = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
        }
      Start-BitsTransfer -Source $url -Destination "$PWD\Docker Desktop Installer.exe"  
      Start-Process 'Docker Desktop Installer.exe' -Wait -ArgumentList 'install', '--accept-license'
    }
    # Remove the Docker Desktop Installer after installation
    $installFileExists = Test-Path -Path "$PWD\Docker Desktop Installer.exe"
    if ($installFileExists) {
      Remove-Item -Path "$PWD\Docker Desktop Installer.exe"
      Write-Host "Docker Desktop Installer.exe has been removed after installation."
    }

# Install all dependencies through Docker
# Setup process for LazyVim/Neovim



