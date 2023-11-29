# xcparse

A command line tool to extract code coverage & screenshots from Xcode 11 XCResult files.

To learn more about Xcode 11's xcresult format, read [Rishab Sukumar's post on the ChargePoint Engineering blog](https://www.chargepoint.com/engineering/xcparse/)

## Installation 

### [Homebrew](https://brew.sh)

Enter the following command into your terminal:

```shell
brew install chargepoint/xcparse/xcparse
```
This will tap into our xcparse Homebrew tap and install the tool on your local machine.

### [Mint](https://github.com/yonaskolb/Mint)

To use xcparse via Mint, prefix the normal usage with mint run ChargePoint/xcparse like so:

```shell
mint run ChargePoint/xcparse xcparse <command> <options>
```

To use a specific version of xcparse, add the release tag like so:

```shell
mint run ChargePoint/xcparse@2.1.0 xcparse --help
```

### Bitrise

Want to use this in [Bitrise](https://www.bitrise.io)? We have an [xcparse Bitrise step](https://github.com/ChargePoint/bitrise-step-xcparse) available in the [Bitrise StepLib](https://github.com/bitrise-io/bitrise-steplib) so you can add xcparse directly from the Bitrise Workflow UI!

See our [Bitrise step's README](https://github.com/ChargePoint/bitrise-step-xcparse/blob/master/README.md) for more information.

## Usage

```
xcparse <command> <options>
```

Below are a few examples of common commands. For further assistance, use the --help option on any command

### Screenshots

```
xcparse screenshots --os --model --test-plan-config /path/to/Test.xcresult /path/to/outputDirectory
```

This will cause screenshots to be exported like so:

![Screenshots exported into folders](Docs/Images/screenshots_options_recommended.png?raw=true)

Options can be added & remove to change the folder structure used for export.  Using no options will lead to all attachments being exported into the output directory.

Options available include:

| Option                   | Description                             |
|--------------------------|-----------------------------------------|
| ```--model```            | Divide by test target model             | 
| ```--os```               | Divide by test target operating system  | 
| ```--test-plan-config``` | Divide by test run configuration        |
| ```--language```         | Divide by test language                 |
| ```--region```           | Divide by test region                   |
| ```--test```             | Divide by test                          |

See ```xcparse screenshots --help``` for a full-listing

#### Test Status

The ```--test-status``` option can allow for whitelisting only screenshots from tests that have a status that matches at least one of the provided status strings

| Examples                                       | Description                            |
|------------------------------------------------|----------------------------------------|
| ```--test-status Success```                    | Passing tests only                     | 
| ```--test-status Failure```                    | Failing tests only                     | 
| ```--test-status Success Failure```            | Passing or failing tests only          |
| ```--test-status 'Expected Failure' Failure``` | Expected failure or failing tests only |
| ```--test-status 'Expected Failure'```         | Expected failure tests only            |


Test status strings can be found by using verbose mode with the screenshots sub-command.

#### Activity Type

The ```--activity-type``` option allows for whitelisting screenshots whose activity type matches at least one of the provided activity type strings.

| Examples                                                                    | Description                   |
|-----------------------------------------------------------------------------|-------------------------------|
| ```--activity-type com.apple.dt.xctest.activity-type.testAssertionFailure```| Test failure screenshots only | 
| ```--activity-type attachmentContainer userCreated```                       | User created screenshots only | 

Note that when an activity type string is provided which doesn't have a reverse-DNS style domain, it is assumed to be of ```com.apple.dt.xctest.activity-type.<activityTypeString>``` and the domain is automatically added.

Therefore, these two are option calls are equivalent:

```--activity-type userCreated attachmentContainer```

```--activity-type com.apple.dt.xctest.activity-type.userCreated com.apple.dt.xctest.activity-type.attachmentContainer```

Activity types can be found in verbose mode.  Below are a listing of common ones:

| Activity Type                                          | Description                             |
|--------------------------------------------------------|-----------------------------------------|
| com.apple.dt.xctest.activity-type.attachmentContainer  | Placeholder activity that contains an attachment, may contain user created screenshot | 
| com.apple.dt.xctest.activity-type.deletedAttachment    | Deleted attachment placeholder activity |
| com.apple.dt.xctest.activity-type.internal             | Internal test step, may have automatic screenshot to show test progression |
| com.apple.dt.xctest.activity-type.testAssertionFailure | Step where the test failed in an assertion, may have failure screenshot |
| com.apple.dt.xctest.activity-type.userCreated          | User created screenshot/attachment |

### Attachments

```
xcparse attachments /path/to/Test.xcresult /path/to/outputDirectory --uti public.plain-text public.image
```

Export all attachments in the xcresult that conform to either the ```public.plan-text``` or the ```public.image``` uniform type identifiers (UTI). The screenshots command, for example, is actually just the attachments command operating a whitelist for ```public.image``` UTI attachments.  Other common types in xcresults are ```public.plain-text``` for debug descriptions of test failures.

Read [this Apple documentation](https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html#//apple_ref/doc/uid/TP40009259-SW1) for a list of publicly documented UTIs.

### Code Coverage

```
xcparse codecov /path/to/Test.xcresult /path/to/exportCodeCoverageFiles
```

This will export the action.xccovreport & action.xccovarchive into your output directory.

### Logs

```
xcparse logs /path/to/Test.xcresult /path/to/exportLogFiles
```

This will export logs & diagnostic files into a per-action folder structure similar to Xcode 10's xcresult format.

![Logs exported into folders](Docs/Images/screenshots_logs.png?raw=true)

### Convert

```
xcparse convert /path/to/AppThinningSizeReport.txt /path/to/outputDirectory --flagVariants sizeLimit
```

This will export a JSON representation of the given App Thinning Size Report to the output directory.

#### Flag Variants

The ```--flag-variants``` option can allow for the generation of an app size violations report with all the app variants that exceed the specified size limit.

| Examples                            | Description                    |
|-------------------------------------|--------------------------------|
| ```--flag-variants 10MB```          | Flags variants that exceed 10MB| 
| ```--flag-variants 13```            | Flags variants that exceed 13MB| 
| ```--flag-variants invalid```       | Flags variants that exceed 10MB|

If a size unit is not specified, the default unit is considered to be megabytes. Similarly, invalid arguments cause a default size limit of 10MB to be used for flagging app size violations.

### Help

```
xcparse --help

xcparse screenshots --help
```

Learn about all the options we didn't mention with ```--help```!
