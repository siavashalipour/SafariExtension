### Design: 

The app has basically two tagets. One is the iOS app and the other is the share extension. 
Application uses the [Realm](https://realm.io) as the database. This descision has been made, since realm is very fast and safe once we want to deal with database and also for this technical test since I am using `App Groups`(more on this later) it was faster/better to use `Realm` instead myself implementing the `Archiving/unArchiving` for the Entites. 
As mentioned above and since this issue came up in our first interview, I have used `App Groups`. As you might know `App Groups` allows applications to share data with their extenstions. The data is consistent and it is in realtime. 

### How To run the App:
Since the app uses `Cocoapods` first before opening the project please run `pod install` and then open the `.xcworkspace` file not the `.xcodeproj`. Also you might get couple of error since you have just installed a new pod. Please do a clean build first. The next step is to change the signing certificate in the project setting to your own certificate (this needs to be set in order to use `App Groups` otherwise the app wouldn't work). Then you need to head to the `Capabilites` tap and add a new `Group` under the `App Groups` section and tick that. You need to the same for the extension target as well (otherwise your app will crash since they are sharing the same data container). 
Since you have changed the `App Groups` name you need to update it in the code as well. Please head to the `SharedCommon` folder in the project navigator and inside the `Constants.swift` file update the `let groupId: String = "to the App Groups name that you just set`. That is all. You now can run the app. You could either choose the extension schema and run it via safari or just run the iOS app and then open up the safari and try to do share. 

#### Note:
I have also put a demo video of the app working in order you if you had difficulties setting up the environment

### What would I have changed if I have more time: 

Definetaly adding some unit test. But in order to have that in place I would have start by creating my own `frameworks` based on the common code that is being shared between the extension and the main app. 
Nicer UI maybe :) 

