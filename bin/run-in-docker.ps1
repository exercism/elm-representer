<#
.SYNOPSIS
    Test runner for run.sh in a docker container
.DESCRIPTION
    Takes the same arguments as run.sh (EXCEPT THAT SOLUTION AND OUTPUT PATH ARE RELATIVE)
    Builds the Dockerfile
    Runs the docker image passing along the initial arguments
    Writes the normalised code to the passed-in output directory.
.PARAMETER Slug
    The slug of the exercise which tests to run.
.PARAMETER InputDirectory
    **RELATIVE** path to solution folder (with trailing slash)
.PARAMETER OutputDirectory
    **RELATIVE** path to output directory (with trailing slash)
.EXAMPLE
    The example below will run the tests of the two-fer solution in the "~/exercism/two-fer" directory
    and write the results to the "~/exercism/results/" directory
    PS C:\> ./run-in-docker.ps1 two-fer path/to/two-fer/solution/folder/ path/to/output/directory/
#>

param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Slug,
    
    [Parameter(Position = 1, Mandatory = $true)]
    [string]$InputDirectory,
    
    [Parameter(Position = 2, Mandatory = $true)]
    [string]$OutputDirectory
)

docker build -t elm-representer .
docker run --network none --mount type=bind,src=$InputDirectory,dst=/solution --mount type=bind,src=$OutputDirectory,dst=/output elm-representer $Slug /solution/ /output/
