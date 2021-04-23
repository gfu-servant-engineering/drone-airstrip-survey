# drone-airstrip-survey

## Table of Contents
1. [Setting up the Project](#setting-up-the-project)
2. [Using the App](#using-the-app)
3. [Misc.](#misc)

## Setting up the Project
After cloning this project there are a couple of steps needed before you can begin working on it.  These include:
* Homebrew
    * Cocoapods
* `info.plist`
    * Setting up your personal appkey

### Homebrew
As you have to develop this project with an apple device hopefully most of you are familiar with [homebrew](https://brew.sh/). If not go to the website and install it.
#### Cocoapods
With that out of the way, one thing we weren't able to put into the project are teh cocoapods as the files were too large.  To install cocoapods simply type in `brew install cocoapods` in the terminal, the `cd` into your project and `pod install`

### info.plist
Everyone should have seperate developer accounts with a personal app key and package name.  Initially we were having issues with people accidentally uploading their plist and so we removed it, an easy alternative would be to [.gitignore](https://git-scm.com/docs/gitignore) or just be mindful of what you are pushing/pulling.

### In Regards to the Info.plist
Everyone should have seperate devloper accounts the 
To get the plist download from [here](https://drive.google.com/file/d/1oHNSjfaonx-_PRQgGn077HARWynbUJ1w/view?usp=sharing) and drop it into the `Maf2` folder, then launch the project from the `<AF2.xcworkspace` file.  On the left hand side there should be a file tree with the `info.plist` highlighted in red.  Click on it, and on the right hand side ofr Xcode, there should be:
<br />
![image](https://media.discordapp.net/attachments/552893768341127181/831282986863165520/unknown.png)
<br />
Press the folder icon and select the newly added `Info.plist`.  You should be good to go!

### Creating a Personal App Key
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

#### In Xcode
1. In the `Info.plist` file, update both your App key and your Bundle Identifier to match your _personal_ key and identifier on the DJI Developer website.
2. Click on the outermost `MAF2.xcodeproj` file
3. Ensure that your "Team" is set to your Apple Developer account
![](drone-airstrip-survey/page2image450849360.png) 

## Using the App
The process of using the app is fairly simple(?)  The goal that they wanted was to only have to use 3 taps before launching a mission.  We weren't able to get to that point but what we did get will be listed below:
<br />
Booting up the app, there should be a `Connect View` button to the left hand side, click on it and it should connect to the drone (you need to have the drone on, and the the controller plugged into the phone).  After it is connected (if it says that it disconnected it might still be actually connected haha!) press the `New Mission` button to get into the bread and butter of the app.  Here you can press and hold on the map to generate waypoints, add the beginning and end points for the drone and click `Load the Mission`.  Once good, press `Start the Mission` and see it goooo!

As a side note you should be able to save the mission with the button and load them from the home page.

## Misc
Here are just some tid bits that we wanted to include:

### Developing in XCode
Unfortunately, because we are working with an iOS application, you will need to use XCode to develop on it, as that's basically the only good ide out there (which isn't saying much, you'll soon grow to hate it as much as well all did haha...).   The issue with xcode thought, or rather one of the issues, is that you have to have a macbook to be able to run it.  There is the work laptop out there for you guys to use, but if multiple of you guys don't have an apple device it might be difficult to get to work.

### Looking Towards the Future
As this is now going to be a three year long endeavor there were some things that we were not able to complete with out project.  Here are some recommendations that we wanted to highlight going into the project next year:

### Fixing the User Interface
We were testing our app on one of our teammate's iphones as that was what we had, but the spec wants us to focus more on ipads.  This isn't too much of an issue as there are constraints you can set up in the XCode storyboard that will automagically make it all work.  That being said, we were unable to finish this part, as well as the ui overhaul.  The year prior to us kind of hacked together a ui so we made a mockup and got most of it complete except for two screens which are listed here:
<br />
![](https://media.discordapp.net/attachments/552893768341127181/834941279220662332/unknown.png)
<br />
![](https://media.discordapp.net/attachments/552893768341127181/834941241992020028/unknown.png)
<br />
Hopefully from these images you can get an idea of where we were heading with the design, and if you don't like it go ahead and change it haha!

### Algorithm
One thing that we had a hard time testng until the end was the most important part of the app: the algorithm.  On oversight we had was the angle of the image as when the drone would turn the images would then switch from horizontal to vertical.  This lead to some pretty crappy [stitches](https://media.discordapp.net/attachments/552893768341127181/833840936126513182/unknown.png) as you can see, so keep that in mind as you look into making it better.  Another recommendation that I would have is to check out the DJI GO 4 app on the appstore.  If you launch the run the drone from our map, then switch to that app you can see the camera view, which hopefully you guys can implement into this app itself!

Another issue was focusing, some of the images that were taken were horribly unfocused so that is another issue, as well as getting the gimbal to look down in the first place (our solution was to just manually angle it down on the controller before launching it, so you might want to find some documentation on that class!)

We should hopefully have some decent documentation for the algorithm as it is, and my hand is getting tired typing so I don't fully feel like explaining how it works, if you want more specific detail if the documentation is not enough, contact Ethan Jensen at ejensen18@georgefox.edu as he wrote the bulk of it (including that documentation).

### main.storyboard
One reoccuring issue that we had when cloning the project was the storyboard wasn't always working, to fix it simply change the path to the actual file in the project, it's a similar process to setting up the `info.plist` so look there for any help!

### "Connection is not successful"
When connecting to the drone, the `connect view` button will sometimes say that it wasn't successful.  You can actually check if it did connect by then going to the `new mission` and looking at the `operator state`.  It should say that it's connected if it is actually connected!

### Offline Maps
One thing we weren't able to implement was the offline maps feature, as the usecase for this project is areas without internet connectivity and as such the maps need to be downloaded beforehand.  There looks to be some interesting ways to go about it with a quick google search, but we'll leave that decision up to you guys!

### Gmail Account
If you ever need to make an account for whatever reason for the project, the username and password that is set up for the personal app key are the same as the google account.
