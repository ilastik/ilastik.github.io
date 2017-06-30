---
layout: documentation
title: Installation
tagline:
category: "Documentation"
group: "basic-documentation"
weight: 0
---

# Installation

ilastik binaries are provided for Windows, Linux, and Mac at our [download page]({{site.baseurl}}/download.html).

**Note: ilastik requires a 64-bit machine.  We do not provide 32-bit binaries.**

Most workflows are available with the [basic ilastik installation](#basic-installation).

Some workflows, however, require the manual installation of a commercial solver.
On *Windows*, the following workflows will only be available after installing the IBM CPLEX solver:

+ Boundary Segmentation with Multicut
+ Tracking (all flavours)
+ Counting (better results with CPLEX)

In order to enable these workflows, please follow the instructions in the section about [commercial solver installation](#solver-setup).

On *Mac* and *Linux* only Learning in the Tracking workflow *requires* a commercial solver (CPLEX or Gurobi).
Furthermore, the results of the Boundary Segmentation with Multicut and the Tracking workflow tend to be more accurate using one of the two commercial solvers.


## Basic Installation <a id="basic-installation"></a>

### Installation on Windows

[Download]({{site.baseurl}}/download.html) the Windows self-extracting installer and run it.
The installer will guide you through the installation process.
You can find an entry for ilastik in the start menu and click it to launch the program.


### Installation on Mac

[Download]({{site.baseurl}}/download.html) the `.tar.bz2` file for your version of OSX and extract its contents with a simple double-click.
Copy ilastik.app to the folder of your choice (usually your `Applications` folder), and double-click to begin.


### Installation on Linux

[Download]({{site.baseurl}}/download.html) the Linux `.tar.bz2` bundle and extract its contents from the terminal:

    tar xjf ilastik-1.*-Linux.tar.bz2

To run ilastik, use the included `run_ilastik.sh` script:

    cd ilastik-1.*-Linux
    ./run_ilastik.sh


-----------------

-----------------

## Commercial Solver Installation <a name="solver-setup"></a>

For some workflows in ilastik, installation of a commercial solver is required.
*IBM CPLEX* is supported by ilastik on all platforms.
Alternatively, *GUROBI* can be used on Linux and Mac.

### CPLEX Installation and Setup

#### Application for Academic License at IBM

IBM CPLEX is a commercial solver which is free for academic use.
Details on the application for an academic license, may be found on
[the IBM Academic Initiative website](https://developer.ibm.com/academic/).
Please note that it might take some days until the application gets approved by IBM.

#### Download IBM CPLEX

Once the license has been approved by IBM, instructions for download will be provided.

The current version of ilastik works with
**IBM ILOG CPLEX Optimization Studio V12.6**.
After choosing the appropriate platform, you have to agree with the IBM license.
Finally, CPLEX may be downloaded and is ready to install.

**Important note: It is not sufficient to download the Trial version of CPLEX since its solver can only handle
very small problem sizes. Please make sure, the correct version is downloaded as described here.**

The following sections contain platform-specific instructions for CPLEX installation on [Windows](#cplex-setup-windows) as well as on [Linux and Mac](#cplex-setup-linux-mac).

#### Setup on Windows <a name="cplex-setup-windows"></a>

Run the installer by double clicking the executable that you've downloaded.

On Windows, there are typically no further modifications needed after installing CPLEX.
After successful installation the *Automatic Tracking Workflow* is displayed on the Start-Screen of ilastik.

If this workflow is not present, something went wrong with the CPLEX installation.
To track down the problem, proceed like this:

* Make sure that the environment variable `CPLEX_STUDIO_DIR1263` is set and points to the proper location.
  You can check this by typing `echo %CPLEX_STUDIO_DIR1263%` at the DOS command prompt.
  The output should be something like `C:\Program Files\IBM\ILOG\CPLEX_Studio1263`.
* Make sure that `cplex` is in the PATH.
  Type `where cplex` at a DOS prompt.
  It should produce something like `C:\Program Files\ibm\ILOG\CPLEX_Studio1263\cplex\bin\x64_win64\cplex.exe` (the path prefix should match the contents of the `CPLEX_STUDIO_DIR1263` variable).
* Make sure that the directory containing `cplex.exe` also contains `cplex1263.dll`, `ILOG.CPLEX.dll`, and `ILOG.Concert.dll`.

The *Automatic Tracking Workflow* should now be displayed on the start screen.
If it doesn't, you may copy the files `cplex1263.dll`, `ILOG.CPLEX.dll`, and `ILOG.Concert.dll` (if you can locate them somewhere) to the *binary* folder of the ilastik installation, usually located at `C:\Program Files\ilastik\bin`.
If it still doesn't work, please [contact us]({{site.baseurl}}/community.html).


#### Setup on Linux and Mac<a name="cplex-setup-linux-mac"></a>

On Linux and Mac, the CPLEX installer comes as a commandline executable (`cplex-someversion.sh` on Linux and `cplex-someversion.bin` on Mac).
To install it, open a terminal and run `bash /path/to/your/cplex-someversion.sh` (or `bash /path/to/your/cplex-someversion.bin` on Mac).

**Hint:** on Mac and most Linux distributions you can drag and drop the installer file into the terminal to get the full path appended to your command line.

CPLEX packages for Linux and Mac do not provide shared versions of all required libraries, but only static variants.
In order to enable CPLEX with ilastik, the static libraries have to be converted.
Before you can convert your static CPLEX libraries into shared library versions, you need to have a compiler installed on your machine.
You can check whether you already have a compiler installed by running the following command in a terminal (open the Terminal app!).

    gcc --version

If no compiler is installed, choose what to do depending on your OS version:

- For Linux, use your OS package manager (e.g. `apt-get`) to install the `gcc` package.
- For all OSX < 10.9, so up to Mountain Lion, you need to install XCode from the AppStore.
  Then you need to go to XCode's Preferences, to the Downloads tab, and install the command line tools.
- For OSX 10.9 Mavericks it suffices to install the command line tools using the following command without installing XCode.

      xcode-select --install

  Then you need to accept the XCode licence by running "sudo gcc" once.

Now you can run a script, that will convert your CPLEX static libraries into shared libraries, and install them into the appropriate directory of your ilastik directory.
Starting with ilastik-1.1.7, this script can be found in ilastik-1.\*/ilastik-meta/ilastik/scripts.
Prior to that version the [script](https://github.com/ilastik/ilastik/blob/master/scripts/install-cplex-shared-libs.sh) needs to be downloaded manually in the terminal:

    wget https://raw.githubusercontent.com/ilastik/ilastik/master/scripts/install-cplex-shared-libs.sh

Navigate to the directory containing the script and execute it:

    # navigate to the script location, e.g. /path/to/ilastik-1.*-Linux/ilastik-meta/ilastik/scripts
    cd /path/to/script
    # Linux:
    bash install-cplex-shared-libs.sh /path/to/your/cplex-root-dir /path/to/ilastik-1.*-Linux
    # Mac:
    bash install-cplex-shared-libs.sh /path/to/your/cplex-root-dir /path/to/ilastik-1.*-OSX.app

In the command above, `/path/to/your/cplex-root-dir` is the location of your cplex studio installation. It should contain directories named `concert` and `cplex`, among others.

**Note:** The above script installs CPLEX directly into your ilastik installation.
Once you've done that, you should not distribute your copy of ilastik to others, unless you have a license to distribute CPLEX.

After a successful installation, the *Tracking with Learning Workflow* will appear on the Start-Screen of ilastik.

In the command above, `cplex-root-dir` is the location of your cplex studio installation. It should contain directories named `concert` and `cplex`, among others.

**Note:** The above script installs CPLEX directly into your ilastik installation.  Once you've done that, you should not distribute your copy of ilastik to others, unless you have a license to distribute CPLEX.

[script]: https://github.com/ilastik/ilastik/blob/master/scripts/install-cplex-shared-libs.sh

After a successful installation, the *Automatic Tracking Workflow* will appear on the Start-Screen of ilastik.
