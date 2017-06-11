# Target iOS Case Study


You have been given an proof-of-concept iOS project that displays, simply, a list of things. Your goal is to expand on the app to display a list of deals currently offered by Target, and to provide additional detailed information on those deals. 

##### Instructions

Please complete all of the following:

1. Fix up the deals list to (as best as you can) match the mockups shown in DealsList.png.
2. Instead of displaying an alert when a deal is selected, instead present a new view that displays details on the view. Use the mockups shown in DealsDetails.png.
3. The deals are currently hardcoded. Use the API at https://target-deals.herokuapp.com (this may be slow to load) to grab the real deals to display in the app.
4. Do something interesting! Add something to the app you think can really make it fun to use.

##### Some guidelines

- This project uses a light but powerful presentation framework called "Tempo". 
> **Do your best to read, understand, and adapt the pattern. If you find it too involved or time consuming, continue the example utilizing whichever pattern you are comfortable with.**

- Feel free to use any open source software you feel helps development. Treat this app as something you control technically.
- Do your best to follow modern iOS conventions and write clean, performant, and extensible code. Imagine that this app will continue to grow.
- Be sure the app looks great on all iPhone sizes!


##### Developer Notes

###### Pre-Build Steps
This project uses [Carthage](https://github.com/Carthage/Carthage "Carthage") as the dependency system.

Be sure to follow the installation instructions for Carthage (I recommend using HomeBrew).

Before building the project make sure to run `carthage bootstrap --platform iOS` which will
pull down and build some frameworks which are then put into $(PROJECT_ROOT)/Carthage/Build/iOS
and the Xcode project references the frameworks from the same folder as above.

As of 6/11/2017 there are 2 main dependencies in the Cartfile:
- [Decodable](https://github.com/Anviking/Decodable "Decodable")

	Decodable is a lightweight way to transform JSON into Swift objects.

- [NYTPhotoViewer](https://github.com/NYTimes/NYTPhotoViewer "NYTPhotoViewer")

	NYTPhotoViewer is used to show the product image when tapped.
	
This project is now also wired into my developer account via Xcode Automatically Managed Signing. 
Make sure to change the dev team and/or bundle IDs as necessary to get your project to build
and run on a device as needed.

######




