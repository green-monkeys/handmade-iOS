# Green Monkeys Handmade App
## Handmade Front End - iOS Swift [Github Link](https://github.com/green-monkeys/handmade-iOS)
## Back End - Node.js Express Hosted on Heroku [Github Link](https://github.com/green-monkeys/handmade_backend)

## [Deployment Site](https://green-monkeys.github.io/handmade-iOS/)
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

### End User License Agreement
View our EULA [here](https://www.eulatemplate.com/live.php?token=6P4s5xCfHJOrPJqsP5s1GYwY6RalQBG8)
### Privacy Policy
View our Privacy Policy [here](https://www.eulatemplate.com/live.php?token=6P4s5xCfHJOrPJqsP5s1GYwY6RalQBG8)
