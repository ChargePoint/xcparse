# Supported Format Descriptions

This is where we keep a listing of the format descriptions from xcresultttol that we support. Format descriptions help us to understand what data structures exist in the xcresult format & update for changes in the latest Xcode.

You can use these to analyze what changed between different versions of Xcode & xcresulttool.

## Generate Format Description 

To get the current format description for your Xcode, run the following in Terminal:

```shell
xcrun xcresulttool formatDescription > ~/Downloads/currentXcodeFormatDescription.txt
```
This will create a text file in your Downloads directory that contains the format description that you can then file compare with the descriptions here.
