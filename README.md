# TZContainerViewController

Progress bar with indicator and labels to track down the progress.

### Installation
Use Swift Package Manager.

### Usage
 In your xib file or Storyboard, click on the UIViewController, go to the Identity Inspector and change the ViewController class  to **TZContainerViewController**. You can also implement/inherit this class
 
 In your TZContainerViewController main view, add another view with the desired height and width, and control-drag **containerView** outlet to it. This is the view which will be the container/host of the other controller views

Push the new controller view
```swift
let newController = UIViewController() // intiate your view
self.push(viewController: newController, animated: true)
```

Pop the current controller view
```swift
self.popViewController(animated: true)
```
You can also pop to any index
```swift
self.popToIndex(1, animated: true)
```

# License
Free to uses



