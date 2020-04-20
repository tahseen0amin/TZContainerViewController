import UIKit

/** Container View Controller that will act more or so as Navigation controller but without the NavigationBar */
open class TZContainerViewController: UIViewController {
    private enum SnapPoint {
        case left
        case right
        case middle
    }
    
    /** This is the view that will be used as the container for child views. They will be added here */
    @IBOutlet open weak var containerView: UIView!
    
    open var currentIndex : Int {
        return self.children.count - 1
    }
    open var animationDuration: TimeInterval = 0.85
    open var animationOption: UIView.AnimationOptions = .curveEaseOut
    
    public func push(viewController controller: UIViewController, animated: Bool) {
        let currentView = self.currentIndex >= 0 ? containerView.subviews[self.currentIndex] : nil
        
        if let destinationView = add(childController: controller) {
            if animated {
                // animate
                UIView.animate(withDuration: self.animationDuration, delay: 0, options: self.animationOption, animations: {
                    if let currentView = currentView {
                        currentView.frame.origin = self.getPosition(snapPoint: .left, frame: self.containerView.bounds)
                    }
                    destinationView.frame.origin = self.getPosition(snapPoint: .middle)
                }, completion: nil)
            } else {
                if let currentView = currentView {
                    currentView.frame.origin = self.getPosition(snapPoint: .left, frame: self.containerView.bounds)
                }
                destinationView.frame.origin = self.getPosition(snapPoint: .middle)
            }
        }
    }
    
    public func popViewController(animated: Bool) {
        let oldIndex = self.currentIndex - 1
        let previousView = oldIndex >= 0 ? containerView.subviews[oldIndex] : nil
        let toRemoveController = self.children[self.currentIndex]
        if let removeView = toRemoveController.view {
            if animated {
                UIView.animate(withDuration: self.animationDuration, delay: 0, options: self.animationOption, animations: {
                    if let previousView = previousView {
                        previousView.frame.origin = self.getPosition(snapPoint: .middle)
                    }
                    removeView.frame.origin = self.getPosition(snapPoint: .right, frame: self.containerView.bounds)
                },completion: { success in
                    if success {
                        toRemoveController.remove()
                    }
                })
            } else {
                if let previousView = previousView {
                    previousView.frame.origin = self.getPosition(snapPoint: .middle)
                }
                removeView.frame.origin = self.getPosition(snapPoint: .right, frame: self.containerView.bounds)
                toRemoveController.remove()
            }
            
        }
    }
    
    public func popToIndex(index: Int, animated: Bool) {
        guard let _ = self.children[exist: index] else {
            debugPrint("Index out of range")
            return
        }
        let previousView = containerView.subviews[index]
        let toRemoveController = self.children[self.currentIndex]
        if let removeView = toRemoveController.view {
            if animated {
                UIView.animate(withDuration: self.animationDuration, delay: 0, options: self.animationOption, animations: {
                    previousView.frame.origin = self.getPosition(snapPoint: .middle)
                    removeView.frame.origin = self.getPosition(snapPoint: .right, frame: self.containerView.bounds)
                },completion: { success in
                    if success {
                        // remove other controller
                        var controllers: [UIViewController] = []
                        for indice in (index + 1)...self.currentIndex {
                            controllers.append(self.children[indice])
                        }
                        for c in controllers {
                            c.remove()
                        }
                    }
                })
            } else {
                previousView.frame.origin = self.getPosition(snapPoint: .middle)
                removeView.frame.origin = self.getPosition(snapPoint: .right, frame: self.containerView.bounds)
                // remove other controller
                var controllers: [UIViewController] = []
                for indice in (index + 1)...self.currentIndex {
                    controllers.append(self.children[indice])
                }
                for c in controllers {
                    c.remove()
                }
            }
        }
    }
    
    // MARK: - HELPERS
    private func getPosition(snapPoint: SnapPoint, frame: CGRect = .zero) -> CGPoint {
        switch snapPoint {
        case .left:
            return CGPoint(x: -frame.width, y: 0)
        case .right:
            return CGPoint(x: frame.maxX, y: 0)
        default:
            return .zero
        }
    }
    
    private func add(childController controller: UIViewController, at snapPoint: SnapPoint = .right) -> UIView? {
        if let destinationView = controller.view {
            addChild(controller)
            destinationView.frame = containerView.bounds
            containerView.addSubview(destinationView)
            // equal Width and height
            destinationView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.0).isActive = true
            destinationView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1.0).isActive = true
            // set frame
            destinationView.frame.origin = getPosition(snapPoint: snapPoint, frame: containerView.bounds)
            controller.didMove(toParent: self)
            return destinationView
        } else {
            return nil
        }
    }
}

public extension UIViewController {
    /** This will remove the view and controller from the parent controller */
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

public extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
