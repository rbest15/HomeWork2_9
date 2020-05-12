import UIKit
import FBSDKLoginKit
import VK_ios_sdk
import GoogleSignIn
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        VKSdk.initialize(withAppId: "7427495")?.uiDelegate = self
        GIDSignIn.sharedInstance()?.clientID = "1084893895308-o8ksmcrtfrimc2k9h1ussvpj43j60sir.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "rdfghdfg", consumerSecret: "dgfhdfgh")
        return true
        
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
        VKSdk.processOpen(url, fromApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String)
        
        GIDSignIn.sharedInstance()?.handle(url)
        
        TWTRTwitter.sharedInstance().application(app, open: url, options: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! [AnyHashable : Any])

        return true
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

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("ДОСТУП К ГУГЛ ПОЛУЧЕН", user.authentication.accessToken)
    }
}
