/*! Copyright 2016 Ayogo Health Inc. */

@objc(PrivacyScreen)
class PrivacyScreenPlugin : CDVPlugin {

    private var overlay : UIView? = nil;


    override func pluginInitialize() {
        self.createOverlay();

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(PrivacyScreenPlugin._didEnterBackground(_:)),
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil
        );

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(PrivacyScreenPlugin._didBecomeActive(_:)),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil
        );
    }



    internal func createOverlay() {
        if #available(iOS 8.0, *) {
            if !UIAccessibilityIsReduceTransparencyEnabled() {
                self.webView.backgroundColor = UIColor.clearColor();

                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light);
                self.overlay = UIVisualEffectView(effect: blurEffect);

                self.overlay?.frame = UIApplication.sharedApplication().windows.last!.bounds;
                self.overlay?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight];

                return;
            }
        }

        self.overlay = UIView(frame: UIApplication.sharedApplication().windows.last!.bounds);
        self.overlay?.backgroundColor = UIColor.blackColor();
    }


    internal func _didEnterBackground(_ notification : NSNotification) {
        if let window = UIApplication.sharedApplication().windows.last {
            window.addSubview(self.overlay!);
        }
    }

    internal func _didBecomeActive(_ notification : NSNotification) {
        UIView.animateWithDuration(0.2,
            animations: { self.overlay?.alpha = 0; }
            completion: { _ in
                self.overlay?.removeFromSuperview();
                self.overlay?.alpha = 1;
            }
        );
    }
}
