import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import VK_ios_sdk
import TwitterKit
import GoogleSignIn
import Social
import AppAuth


@IBDesignable class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    let fbLogin = FBLoginButton()
    let vkLogin = UIButton()
    let twittLogin = TWTRLogInButton()
    let googleLogin = GIDSignInButton()
    let stackView = UIStackView()
    let stackViewSpacing = CGFloat(5)
    let buttonsCount = 4
    
    let viewImagePick = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackViewWithLogins()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        VKSdk.initialize(withAppId: "7427495")?.register(self)
    }
    @IBAction func pickImage(_ sender: Any) {
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.allowsEditing = true
        present(ipc, animated: true)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        guard (imageView.image) != nil else {
            return
        }
        if imageView.image != nil {
            let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
            vc.title = "Share this image!"
            present(vc, animated: true)
        }
    }
    
    fileprivate func configureStackViewWithLogins() {
        imageView.contentMode = .scaleToFill
        
        fbLogin.delegate = self
        fbLogin.permissions = ["email"]
        
        vkLogin.setTitle("Sign in with VK", for: .normal)
        vkLogin.addTarget(self, action: #selector(loginToVK), for: .touchUpInside)
        vkLogin.backgroundColor = .blue
        vkLogin.layer.cornerRadius = 3
        
        stackView.addArrangedSubview(fbLogin)
        stackView.addArrangedSubview(vkLogin)
        stackView.addArrangedSubview(twittLogin)
        stackView.addArrangedSubview(googleLogin)
        
        
        let  stackViewHeight = CGFloat(200)
        stackView.bounds = CGRect(x: 0, y: 0, width: 300, height: stackViewHeight)
        stackView.spacing = stackViewSpacing
        stackView.center.x = view.center.x
        stackView.center.y = view.center.y + view.center.y / 2
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        view.addSubview(stackView)
    }
    
    @objc func loginToVK(){
        VKSdk.authorize(["friends"])
    }
    
}

extension ViewController : LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("ДОСТУП К FB ПОЛУЧЕН", result?.token)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("FB LOG OUT")
    }
    
    
}

extension ViewController : VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print("ДОСТУП К ВК ПОЛУЧЕН", result.token)
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("VK AUTH FAILED")
    }
    
    override func vks_viewControllerWillDismiss() {
        print("dissmised VK")
    }
}

extension ViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{ return }
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
}
