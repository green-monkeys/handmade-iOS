# Green Monkeys Handmade App
## An iOS App for Artisan Collectives
One of the main reasons that Artisans are unable to get themselves listed on Amazon's Handmade store is the requirement for a bank account. Now, artisans can form collectives or enter with existing ones to get their products listed on Handmade. This opens up a wealth of new opportunities for artisans located in remote or rural areas without the need for a bank account or consistent connection to the web. 

## [Deployment Site](https://green-monkeys.github.io/handmade-iOS/)

### Getting Started
#### Installing the iOS App
##### Required Tools:
- Mac running MacOS 10.13.6 (High Sierra) or later
- [Xcode](https://developer.apple.com/xcode/)
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)
##### Required Hardware:
- MacBook (Late 2009 or newer)
- MacBook Pro (Mid 2010 or newer)
- MacBook Air (Late 2010 or newer)
- Mac mini (Mid 2010 or newer)
- iMac (Late 2009 or newer)
- Mac Pro (Mid 2010 or newer)
##### Deployment Device:
- iOS Version 11 or Later

#### Build and Deployment Instructions
1. Clone [Github Repository](https://github.com/green-monkeys/handmade-iOS)
1. Install Cocoapods
   1. Use `pod install` in the project directory to install.
   1. Open the .xcworkspace file in Xcode
1. Select the deployment device you want to use
1. Launch the program with the play button

Issues getting set up? Email casato@calpoly.edu with your questions.

#### Back End Specifications
```
capstone406.herokuapp.com
/cga
    GET /:cgaId
        Returns CGA object with ID :cgaId
    POST /
        Body
            - email
            - firstName
            - lastName
    DELETE /:cgaId
        Deletes CGA with ID :cgaId
    GET /
        Query
            - email
    GET /artisans
        Query
            - email
    GET /image
        Query
            - email
/artisan
    GET /:artisanId
        Returns Artisan object with ID :artisanId
    POST /
        Body
            - email
            - firstName
            - lastName
            - cgaId
            - password
            - salt
    DELETE /:artisanId
        Deletes Artisan with ID :artisanId
    GET /
        Query
            - username
    GET /image
        Query
            - username
/payout
    GET /:payoutId
        Returns Payout object with ID :payoutId
    POST /
        Body
            - cgaId
            - artisanId
            - amount
    DELETE /:payoutId
        Deletes Payout with ID :payoutId
/aws
    POST /image
        Body (form-data)
            - image
        Query
            - folder (artisan|cga)
            - filename (artisan username|cga email)
```

### Github Repositories
#### [Handmade Front End - iOS Swift](https://github.com/green-monkeys/handmade-iOS)
#### [Back End - Node.js Express Hosted on Heroku](https://github.com/green-monkeys/handmade_backend)

### End User License Agreement
View our EULA [here](https://www.eulatemplate.com/live.php?token=6P4s5xCfHJOrPJqsP5s1GYwY6RalQBG8)
### Privacy Policy
View our Privacy Policy [here](https://www.eulatemplate.com/live.php?token=6P4s5xCfHJOrPJqsP5s1GYwY6RalQBG8)
