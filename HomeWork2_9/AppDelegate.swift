import UIKit
import FBSDKLoginKit
import VK_ios_sdk
import GoogleSignIn
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        GIDSignIn.sharedInstance()?.clientID = "1084893895308-o8ksmcrtfrimc2k9h1ussvpj43j60sir.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "123456", consumerSecret: "123456")
        VKSdk.initialize(withAppId: "7472137")?.uiDelegate = self
        return true
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        ApplicationDelegate.shared.application( application, open: url, sourceApplication: sourceApplication, annotation: annotation )
        
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        
        GIDSignIn.sharedInstance()?.handle(url)
        
        TWTRTwitter.sharedInstance().application(application, open: url, options: [:])
        return true
    }
}



extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("ДОСТУП К ГУГЛ ПОЛУЧЕН", user.authentication.accessToken)
    }
}

extension AppDelegate : VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        let vc = UIApplication.shared.keyWindow?.rootViewController
        if vc?.presentedViewController != nil {
            vc?.dismiss(animated: true, completion: {
                vc?.present(controller, animated: true)
            })
        } else {
            vc?.present(controller,animated: true)
        }
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
}
