# xcparse

A command line tool to extract code coverage & screenshots from Xcode 11+ XCResult files.

## Usage


```
xcparse [-hq] [-s xcresultPath destination] [-x xcresultPath destination]
```

### Modes


#### Interactive Mode
When the user runs xcparse with no arguments, xcparse runs in interactive mode. In this mode the user is prompted to enter options and arguments as required.

#### Static Mode
This is the default mode in which xcparse runs if the user specifies an option.

### Options

1. -s or --screenshots: Extracts screenshots from specified *.xcresult file and saves them in specified destination folder.
2. -x or --xcov: Extracts coverage from specified *.xcresult file and saves it in specified destination folder.
3. -q or --quit: Exits interactive mode.
4. -h or --help: Prints usage information

**Arguments must be specified when xcparse is run with the --xcov or --screenshots options.**
