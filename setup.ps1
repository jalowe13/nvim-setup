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
      # Install Docker, other processors later
       $url = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
      Start-BitsTransfer -Source $url -Destination "$PWD\Docker Desktop Installer.exe"  
      Start-Process 'Docker Desktop Installer.exe' -Wait -ArgumentList 'install', '--accept-license'
    }
    # Remove the Docker Desktop Installer after installation
    $installFileExists = Test-Path -Path "$PWD\Docker Desktop Installer.exe"
    if ($installFileExists) {
      Remove-Item -Path "$PWD\Docker Desktop Installer.exe"
      Write-Host "Docker Desktop Installer.exe has been removed after installation."
    }

# Creating Docker container for Neovim using Windows Server 2019
$dockerContainerOsType = docker version --format '{{.Client.Os}}'

Write-Host "$dockerContainerOsType"

if ($dockerContainerOsType -eq "windows") {
  Write-Host "Docker container is running on Windows."
  Write-Host "If you have recieved an error please run at an elevated command prompt."

} else {
  Write-Host "Docker container is not running on Windows. Your system might need to restart again as the container defaults to linux on install."
  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
  Enable-WindowsOptionalFeature -Online -FeatureName Containers -All
  & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon
}
# Build Dockerfile and run Docker container for Neovim and add GIT
$imageExists = docker images | Where-Object { $_ -match "neovim" }
if (-not $imageExists) {
  Write-Host "Neovim image does not exist. Building image."
  # Build and run the Docker container for Neovim
  docker build -t neovim -f Dockerfile .
}  
  docker rm -f neovimcontainer 
  docker run --name neovimcontainer -d neovim
  # Setup process for LazyVim/Neovim through powershell in Docker
  # Hello world would be the first thing to do in the container but represents the setup process
  docker exec -it neovimcontainer powershell -Command { 
  echo "Starting Neovim Installation with Jacob's LazyVim IDE setup"
  echo "Installing Dependencies with Chocolatey and Git"
  Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
  RefreshEnv
  choco feature enable -n=allowGlobalConfirmation
  echo 'Installing Neovim'
  choco install neovim -y
  echo 'Pulling NeoVim from git'
  git clone https://github.com/LazyVim/starter $env:nvimPath
  echo 'Setting up LazyVim'
  $env:Path += ";$env:nvimPath\bin"
  RefreshEnv
  nvim
  ; powershell
  }



