/*! Copyright 2016 Ayogo Health Inc. */

@objc(PrivacyScreen)
class PrivacyScreenPlugin : CDVPlugin {

    private var overlay : UIView? = nil;


    override func pluginInitialize() {
        self.createOverlay();

        NotificationCenter.default.addObserver(self,
            selector: #selector(PrivacyScreenPlugin._didEnterBackground(_:)),
            name: UIApplication.willResignActiveNotification,
            object: nil
        );

        NotificationCenter.default.addObserver(self,
            selector: #selector(PrivacyScreenPlugin._didBecomeActive(_:)),
            name:  UIApplication.didBecomeActiveNotification,
            object: nil
        );
    }



    internal func createOverlay() {
        if #available(iOS 8.0, *) {
            if !UIAccessibility.isReduceTransparencyEnabled {
                self.webView.backgroundColor = UIColor.clear;

                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light);
                self.overlay = UIVisualEffectView(effect: blurEffect);

                self.overlay?.frame = UIApplication.shared.windows.last!.bounds;
                self.overlay?.autoresizingMask = [.flexibleWidth, .flexibleHeight];

                return;
            }
        }

        self.overlay = UIView(frame: UIApplication.shared.windows.last!.bounds);
        self.overlay?.backgroundColor = UIColor.black;
    }


    @objc internal func _didEnterBackground(_ notification : NSNotification) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.overlay!);
        }
    }

    @objc internal func _didBecomeActive(_ notification : NSNotification) {
        UIView.animate(withDuration: 0.2,
            animations: { self.overlay?.alpha = 0; },
            completion: { _ in
                self.overlay?.removeFromSuperview();
                self.overlay?.alpha = 1;
            }
        );
    }
}
