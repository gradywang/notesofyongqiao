# Developping Golang project with eclipse

This Doc will install goclipse plugin in eclise to developping golang project, refer to [here](
https://github.com/GoClipse/goclipse/blob/latest/documentation/Installation.md#installation) for the details.

My [forked dir](https://github.com/gradywang/goclipse).


## Quick steps

 * Install Java VM version 8 or later.
 * Install Eclipse 4.6 (Neon) or later, this doc uses `eclipse-cpp-neon-R-macosx-cocoa-x86_64.tar.gz` as an example.
 * CDT 9.0 or later (**This will be installed or updated when install goclipse plugin, and if you use eclipse with "Eclipse IDE for C/C++ Developers", the CDT has be installed by default**).
 * Download [goclipse plugin](https://github.com/GoClipse/goclipse.github.io/archive/master.zip) and unpack the archive and use the `releases` directory as a Local repository instead of the Update Site URL. Uncheck the option "Contact all updates sites during installation to find required software" so only the local repository is used. (**NOTE: Check all in pop up windows**)
 * Install the required go tools
   * [gocode](https://github.com/nsf/gocode):
   ```
   # export GOPATH=/Users/yqwyq/go-tools
   # export PATH=$PATH:$GOPATH/bin
   # go get -u github.com/nsf/gocode 
   or windows: # go get -u -ldflags -H=windowsgui github.com/nsf/gocode
   ```
   * [guru](https://docs.google.com/document/d/1_Y9xCEMj5S-7rv2ooHpZNH15JgRT5iM742gJkw5LtmQ/edit):
   ```
   # go get   golang.org/x/tools/cmd/guru
   # go build golang.org/x/tools/cmd/guru
   # mv guru $(go env GOROOT)/bin                   (for example)
   # guru -help
   Go source code guru.
   #Usage: guru [flags] <mode> <position>
   ```
   * [godef](https://github.com/rogpeppe/godef)
   ```
   # go get github.com/rogpeppe/godef
   ```
 * Configure the eclipse for Go
 * Refer to [User Guide](https://github.com/GoClipse/goclipse/blob/latest/documentation/UserGuide.md#configuration) to manage your Golang project.
