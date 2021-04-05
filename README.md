# drone-airstrip-survey
- - - -

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
	* Click on the outermost `MAF2.xcodeproj` file
	* Ensure that your “Team” is set to your Apple Developer account
![](drone-airstrip-survey/page2image450849360.png) 
