# Introduction to this project
This project is based on a `dotnet new` template for grate, an opinionated example on how to use grate with dotnet projects
to organize the SQL scripts.

The template was installed using: 

```
dotnet new -i grate.dotnet-template
```

With the template installed, the project was created using the following command: 

```
mkdir 696fd374-e61c-4021-8970-36b6cb97591f
cd 696fd374-e61c-4021-8970-36b6cb97591f
dotnet new grate --database 696fd374-e61c-4021-8970-36b6cb97591f
```

# Getting Started with grate
grate is an automated database deployment (change management) system that allows you to use plain old .sql scripts but gain much more.

For more info, see: https://erikbra.github.io/grate/getting-started/ 

## A brief walk-through of the generated project.

This projects (ab)uses a `.csproj` file to store just SQL files, and some related tools.
In the project file we override the default `Build` and `ResolveReferences` targets of msbuild, to try 
to avoid creating any DLLs, which we don't want. There are also a few properties that makes `dotnet pack` include
content files in the output, and make the result appropriate for distributing SQL files instead.

The project includes a `.config` folder, which specifies which .net local tool to use (grate and gitversion).

## Using the project

For both local development, and in CI/CD scenarios, to run the 
database migration (which grate calls it), you need to set a couple of environment variables:

* ConnectionStrings__696fd374-e61c-4021-8970-36b6cb97591f
* GrateEnvironment

then you can just run the `Deploy.ps1` script. It should install grate as a .net local tool, and call it with the 
correct parameters.

## Running locally

To migrate your local database, simply, in the project directory (that means **this** folder), run: 

```pwsh
❯ ./Deploy.ps1 
```

## Packaging your new project

The template creates a project fit for packaging as a `.nupkg` and shipping. To package it, just run 
```pwsh
nuget pack
```

in your newly created project directory. This should create a `.nupkg` file (which is simply a zip-file 
with a special file structure and a different extension), which can be downloaded somewhere (build server, etc), and 
run.

## Using you packaged project

To use your project, use some way of downloading the `.nupkg`, and just use the files to run the install scripts. 
You can use nuget, but it's not a necessity, you can just download the file from somewhere, and treat it as a zip 
file, if that better suits your needs.

Example, using NuGet:

```pwsh
❯ nuget install 696fd374-e61c-4021-8970-36b6cb97591f -OutputDirectory somewhere -DirectDownload -Source /tmp/696fd374-e61c-4021-8970-36b6cb97591f/package/
❯ cd ./somewhere/696fd374-e61c-4021-8970-36b6cb97591f.1.0.0/content/
❯ ./Deploy.ps1 
```
