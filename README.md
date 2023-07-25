# Introduction 
This repo contains a `dotnet new` template for grate, an opinionated example on how to use grate with dotnet projects
to organize the SQL scripts.

# Getting Started
To change/develop templates here, the following resources are recommended:

* https://docs.microsoft.com/en-us/nuget/create-packages/creating-a-package#from-a-convention-based-working-directory
* https://docs.microsoft.com/en-us/visualstudio/msbuild/how-to-extend-the-visual-studio-build-process?view=vs-2019
* https://docs.microsoft.com/en-us/dotnet/core/tools/custom-templates
* https://docs.microsoft.com/en-us/dotnet/core/tutorials/cli-templates-create-item-template

There are more good samples on how to create dotnet new templates here: https://github.com/dotnet/dotnet-template-samples

## A brief walk-through of the grate.dotnet-template project.

This project is a template project. That means that it is a template that contains templates for other
projects. So, it contains _two_ csproj files: The project file itself, `grate-dotnet-template`, and 
a `.csproj` file in the templates folder, which is the basis of the new projects.

Both projects (ab)use `.csproj` files to store just SQL files, and some related tools, but in a little different ways.
In both cases, however, we override the default `Build` and `ResolveReferences` targets of msbuild, to try 
to avoid creating any DLLs, which we don't want. There are also a few properties that makes `dotnet pack` include
content files in the output, and make the result appropriate for distributing SQL files instead.

The template project includes a `.template.config` folder, with template settings (metadata, replacement strings, etc). 
This is not included in the resulting project from running the `dotnet new` command. However, the rest of the
`templates` folder, including the `.config` folder, which specifies a .net local tool to use (grate), is included.

## Packaging the template

To package up the template, simply run 

```powershell
dotnet pack
```

The resulting `.nupkg` in the `package` folder contains a template that can be installed on client machines, and used for creating new projects
of this type. This nupkg should be pushed to a nuget repo.


## Installing the template

To use the template, you first need to install it. If you are developing the template itself, locally, you can install it 
from the `.nupkg` file directly:

```pwsh
dotnet new install <PATH_TO_NUPKG_FILE>
```

e.g, in the grate-dotnet-template folder:
```pwsh
dotnet pack
dotnet new install ./package/grate.dotnet-template.0.0.1.nupkg
```

If you just want to use the latest published version of the package, just install it using the package Id 
(assuming you or someone else have pushed it to a nuget repo you have in your sources):

```pwsh
dotnet new install grate.dotnet-template
```

More details here on the different ways to install a template: 
https://docs.microsoft.com/en-us/dotnet/core/tools/custom-templates#installing-a-template

## Using the template

Given that you have installed the template, as described above, you can use the template to create new database projects:

```pwsh
cd /tmp/
mkdir TestProject
cd TestProject
dotnet new grate --database MyDatabase
```

This will give you a new project skeleton in the current directory, with a couple of scripts to run them with grate too.

To run the database migration (which grate calls it), you need to set a couple of environment variables:

* ConnectionStrings__MyDatabase
* GrateEnvironment

then you can just run the `Deploy.ps1` script. It should install grate as a .net local tool, and call it with the 
correct parameters.

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
❯ nuget install MyDatabase -OutputDirectory somewhere -DirectDownload -Source /tmp/MyDatabase/package/
❯ cd ./somewhere/MyDatabase.1.0.0/content/
❯ ./Deploy.ps1 
```
