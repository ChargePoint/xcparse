# xcparse

A command line tool to extract code coverage & screenshots from Xcode 11+ XCResult files.

## Installation 

Enter the following command  in terminal.

```
brew install chargepoint/xcparse/xcparse
```
This will tap into our xcparse homebrew tap and install the tool on your local machine.

## Usage

```
xcparse [-phq] [-s xcresultPath destination] [-x xcresultPath destination]
```

**xcparse only accepts a single option at a time.** 

### Modes


#### Interactive Mode
When the user runs xcparse with no arguments, xcparse runs in interactive mode. In this mode the user is prompted to enter options and arguments as required.

#### Static Mode
This is the default mode in which xcparse runs if the user specifies an option.

### Options

1. -s or --screenshots: Extracts screenshots from specified *.xcresult file and saves them in specified destination folder.
2. -x or --xcov: Extracts coverage from specified *.xcresult file and saves it in specified destination folder.
3. -q or --quit: Exits interactive mode.
4. -h or --help: Prints usage information.
5. -p or --xcpretty: Exports *.xcresult logs in xcpretty-json-format.

**Arguments must be specified when xcparse is run with the --xcov or --screenshots options.**

## Useful Commands

1. brew untap - Untaps from specified homebrew tap
2. brew uninstall - Uninstall homebrew tool
