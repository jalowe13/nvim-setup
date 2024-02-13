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
  Write-Host "Neovim image does not exist. Building image and recompiling container."
  # Build and run the Docker container for Neovim
  docker build --no-cache -t neovim -f Dockerfile .
  docker rm -f neovimcontainer
} 
  docker run --isolation=hyperv --name neovimcontainer -m 5g --cpus=3 --mount source=dev,target=C:/dev -d neovim
  docker stop neovimcontainer
  $CurrentDirectory = Get-Location
  docker cp $CurrentDirectory/lua/plugins_env/color-schemes.lua neovimcontainer:C:/Users/ContainerAdministrator/AppData/Local/nvim/lua/plugins/color-schemes.lua
  docker cp $CurrentDirectory/lua/plugins_env/lsp-config.lua neovimcontainer:C:/Users/ContainerAdministrator/AppData/Local/nvim/lua/plugins/lsp-config.lua
  docker run --isolation=hyperv --name neovimcontainer -m 5g --cpus=3 --mount source=dev,target=C:/dev -d neovim
  docker start neovimcontainer
  echo "Copying configuration files to container."
# Execute powershell again
  docker exec -it neovimcontainer powershell -Command {
    $env:Path += ";C:\\tools\\msys64\\mingw64\\bin"
    cd C:\\dev
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "                       Welcome to Jacob's Dev Environment!"
    echo "                          Enter the editor with 'nvim'"
    echo "                            Exit with CTRL+P CTRL+Q"
    echo "Since this is your first time setup please wait for all the plugins in LazyVim to complete"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    ; powershell
  }


