try {
    docker version
    Write-Host "Docker is installed and running."

  } catch {
    Write-Host "Docker is not installed or running."
  }
  docker exec -it neovimcontainer powershell -Command {
    $env:Path += ";C:\\tools\\msys64\\mingw64\\bin"
    cd C:\\dev
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "          Welcome to Jacob's Dev Environment!"
    echo "             Enter the editor with 'nvim'"
    echo "              Exit with CTRL+P CTRL+Q"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    ; powershell

  }
