try {
    docker version
    Write-Host "Docker is installed and running."

  } catch {
    Write-Host "Docker is not installed or running."
  }
  docker run --name neovimcontainer -d neovim
  docker exec -it neovimcontainer powershell -Command {
    $env:Path += ";C:\\tools\\msys64\\mingw64\\bin"
    nvim
    ; powershell
  }
