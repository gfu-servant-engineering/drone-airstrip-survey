# drone-airstrip-survey

## Table of Contents:
1. [Info.plist](#getting-the-plist)
2. [Creating a Personal App Key](#creating-a-personal-app-key)
3. [Setting up Cocoapods](#cocoapods)
4. [Warnings](#warnings)
---

## Getting The plist
Due to some issues that we had over this last year we decided to remove the `info.plist` from the github as some people kept forgetting to not push it, this could easily be resolved with a .gitignore, but yeah that's up to you haha.
That being said, if you pull the repo you won't actually have the file, so you can get it from [here](https://drive.google.com/file/d/1oHNSjfaonx-_PRQgGn077HARWynbUJ1w/view?usp=sharing) and decide if you want to add it to the repo or just use the drive.

### Adding The `Info.plist` To The Project
After grabbing the `plist` from the link, go into your project and paste it into the `Maf2/` folder, afterwards launch the project from the `MAF2.xcworkspace` file and after opening the filetree on the left, there should be the `info.plist` highlighted in red.  Click on it, and on the right hand side of Xcode, there should be:
<br />
![image](https://media.discordapp.net/attachments/552893768341127181/831282986863165520/unknown.png)
<br />
Press the folder icon and select the newly added `Info.plist`.  You should be good to go!


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
	1. Name the project with the convention `MAF-YOURNAME` (i.e. `MAF-JOHN`)
	2. Set the Software Platform to `iOS`
	3. Set the Package Name: `com.MAF-Yourname` (i.e. `com.MAF-John`)
	4. Set the Category: Agricultural Applications
	5. Set the Description: Any description

## In Xcode
1. In the `Info.plist` file, update both your App key and your Bundle Identifier to match you _personal_ key and identifier on the DJI Developer website.
2. Click on the outermost `MAF2.xcodeproj` file
3. Ensure that your “Team” is set to your Apple Developer account
![](drone-airstrip-survey/page2image450849360.png) 

## Cocoapods
As the pods we are using is fairly large we decided to keep it out of the repository, so you'll have to go in a install them yourselves. This should only need to be done if your pod folder/`xcodeproj` is highlighted red.
1. Open a terminal and `cd` into your repo
2. `pod install`

If you don't have cocoapods installed:
1. Open a terminal
2. `brew install cocoapods`


---
## Warnings

### In Regards to the Info.plist
Everyone should have seperate developer accounts the personal app key and package name should all be different.
This is completely fine, but everyone should be aware that this information is stored in the `info.plist` file.

Make sure to not push your `.plist` file to the project unless you have good reason to, as it will mess up everyone else's project. You could either setup a [.gitignore](https://git-scm.com/docs/gitignore) or just be mindful of what you are pushing/pulling.

## Developing in XCode
Unfortunately to develop Swift code for an iOS application you will have to use a macOS product as XCode is the only decent ide for this type of project, and macOS is the only OS on which you can develop an iOS application.  There is the company-provided Macbook that one person can use, but if not everyone owns an Apple device, it will be difficult to develop this project.
