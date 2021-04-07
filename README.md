# drone-airstrip-survey

## Table of Contents:
1. [Creating a Personal App Key](#creating-a-personal-app-key)
2. [Warnings](#warnings)
---

## Creating a Personal App Key
1. Go to [http://developer.dji.com](http://developer.dji.com)
2. Click on the top right user icon
3. Click login
4. Login with the following credentials:
	* username: droneSurveyMAF@gmail.com
	* password: servantMAF2020! 
5. Click on the blue “Create App” button
![](drone-airstrip-survey/page1image391114816.png) 
6. Set the following parameters to:
	1. Name the project with the convention `MAF-YOURNAME`
	2. Set the Software Platform to `iOS`
	3. Set the Package Name: `com.MAF-Yourname` (i.e. `com.MAF-John`)
	4. Set the Category: Agricultural Applications
	5. Set the Description: Any description

## In Xcode
1. In the `Info.plist` file, update both your App key and your Bundle Identifier to match you _personal_ key and identifier on the DJI Developer website.
2. Click on the outermost `MAF2.xcodeproj` file
3. Ensure that your “Team” is set to your Apple Developer account
![](drone-airstrip-survey/page2image450849360.png) 

---
## Warnings

### In Regards to the Info.plist
Due to everyone (should) having seperate developer accounts the personal app key and package name should all be different.
This is completely fine, but everyone should be aware that this information is stored in the `info.plist` file.

So make sure to not push your plist file to the project unless you have good reason to as it will mess up everyone else's project.  You could either setup a [.gitignore](https://git-scm.com/docs/gitignore) or just be mindful of what you are pushing/pulling.

## Developing in XCode
Unfortunately to develop swift code for an iOS application you will have to use a macOS product as XCode is the only decent ide for this type of project.  There the company macbook that one person can use, but if not everyone owns an apple device, it may be difficult to develop this project.
