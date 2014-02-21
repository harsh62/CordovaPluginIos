================================================================================
Product Name: TIBCO Silver Mobile (R)
Release Version: 2.0.0
Release Date: May 2013

================================================================================
Introduction

The Silver Mobile create_project.sh script will create a Silver Mobile native
client for iOS Xcode project with all build dependencies and required folder
references setup.  The script expects to be run from the bin folder of the
distributed archive.

Upon first project creation, if you do not have SiverMobileCore.embeddedframework
installed on your machine at either the path specified on command line or the
default location \Users\Shared\Tibco\SilverMobile\Frameworks, the script will
install SilverMobileCore.embeddedframework at that path.

This script will not upgrade an existing embedded framework.  If you are
creating a new project from a newer distribution release, we recommend choosing
a new path for your embedded framework location otherwise the script will noticed
the path is already existing and not install the newer framework.

================================================================================
Usage

./create_project.sh <YourProjectName> <com.your.bundle.prefix> <PathToCreatedProject> [<AbsoluteEmbeddedFrameworkPath> <YourCompanyName>]

Three command line arguments are required:
      1. <YourProjectName> - as a valid c identifier
      2. <your.bundle.prefix> - in reverse domain notation
      3. <PathToCreatedProject> - directory to place the created Xcode project

You can optionally include the following additional arguments:
      4. <AbsoluteEmbeddedFrameworkPath> - path to where you want or have already
      	 installed SilverMobileCore.embeddedframework
      5. <YourCompanyName> - Name of your company to appear in comments of source files.
         If not provided the Xcode default of __MyCompanyName__ will appear.

After successfully running the script you will be able to run your project in
iOS simulator or device if you have a valid device and developer profile.

================================================================================
Supported Platforms

Silver Mobile Client System and Software Requirements
	
	* MAC OS X 
	* Xcode 4.0 or later
	* iOS SDK 5.1 or later
        
================================================================================
TIBCO Product Support

Check the TIBCO Product Support web site at https://support.tibco.com for
product information that was not available at release time. Entry to this site
requires a username and password. If you do not have one, you can request one.
You must have a valid maintenance or support contract to use this site.

================================================================================
Copyright (C) 2012 TIBCO Software Inc. ALL RIGHTS RESERVED.
TIBCO Software Inc. Confidential Information
        

    



