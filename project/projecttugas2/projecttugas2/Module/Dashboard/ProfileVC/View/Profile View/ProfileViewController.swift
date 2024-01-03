import UIKit
import Reachability
import FloatingPanel
import FirebaseStorage
import FirebaseAuth
import FirebaseCore
import RxSwift
import RxCocoa
import SkeletonView
import CoreData

class ProfileViewController: UIViewController, FloatingPanelControllerDelegate {
    
    // MARK: - Item Outlet
    @IBOutlet weak var changePhotoLbl: UILabel!
    @IBOutlet weak var historyLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var settingsBtn: UIImageView!
    @IBOutlet weak var seeAllHistory: UILabel!
    @IBOutlet weak var historyCollection: UICollectionView!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var phoneNumberText: UILabel!
    @IBOutlet weak var passwordText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    
    
    // MARK: - Variable
    let refreshControl = UIRefreshControl()
    let profileViewModel = ProfileViewModel()
    let bag = DisposeBag()
    let pickerImage = UIImagePickerController()
    let userLogin: String = "isLogin"
    var errorHandlingController: ErrorHandlingController?
    var fpc: FloatingPanelController!
    var imageChoosen = [UIImagePickerController.InfoKey: Any]()
    var data: User?
    var historyItems: [HistoryModel] = [] {
        didSet {
            historyCollection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupImagePicker()
        configureView()
        setupLocalizedStrings()
        errorHandlingController = ErrorHandlingController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        bindData()
        getImageFromFirbaseStorage()
        historyCollection.reloadData()
    }
    
    // MARK: - Function Data
    func setupLocalizedStrings() {
        changePhotoLbl.text = .localized("changephoto")
        galleryBtn.setTitle("gallery")
        cameraBtn.setTitle("camera")
        usernameLbl.text = .localized("username")
        passwordLbl.text = .localized("password")
        phoneNumberLbl.text = .localized("phone")
        historyLbl.text = .localized("history")
        seeAllHistory.text = .localized("viewall")
    }
    
    func configureView() {
        toMore()
        historyCollection.delegate = self
        historyCollection.dataSource = self
        historyCollection.registerCellWithNib(HistoryCollectionViewCell.self)
        historyCollection.showsHorizontalScrollIndicator = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(seeAllHistoryTapped))
        seeAllHistory.addGestureRecognizer(tapGesture)
    }
    
    func setupUI() {
        viewUser.layer.cornerRadius = viewUser.frame.width / 20
        viewUser.layer.shadowColor = UIColor.black.cgColor
        viewUser.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewUser.layer.shadowRadius = 2
        viewUser.layer.shadowOpacity = 0.2
        viewUser.layer.masksToBounds = false
    }
    
    func setupImagePicker() {
        galleryBtn.addTarget(self, action: #selector(onTapGallery), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(onTapCamera), for: .touchUpInside)
        profileImage.layer.cornerRadius = (profileImage?.frame.size.width ?? 0.0) / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    func showMoreSettings() {
        let floatingPanel = MoreSettingsViewController()
        floatingPanel.delegate = self
        fpc.surfaceView.appearance.cornerRadius = 20
        fpc.set(contentViewController: floatingPanel)
        present(fpc, animated: true, completion: nil)
    }
    
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return MoreSettingsFloatingPanel()
    }
    
    func toMore() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapMoreSettings))
        settingsBtn.addGestureRecognizer(tapGesture)
        settingsBtn.isUserInteractionEnabled = true
    }
    
    func userLoggedOut(_ isLogin:Bool) {
        BaseConstant.userDefaults.set(isLogin, forKey: userLogin)
        BaseConstant.userDefaults.synchronize()
    }
    
    func clearCoreData(forUserID userID: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Cart.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Failed to clear CoreData: \(error)")
        }
    }
    
    // MARK: - Function Skeleton View
    
    func showSkeletonView() {
        profileImage.showAnimatedSkeleton()
        nameText.showAnimatedSkeleton()
        passwordText.showAnimatedSkeleton()
        phoneNumberText.showAnimatedSkeleton()
        historyCollection.showAnimatedSkeleton()
    }
    
    func hideSkeletonView() {
        profileImage.hideSkeleton()
        nameText.hideSkeleton()
        passwordText.hideSkeleton()
        phoneNumberText.hideSkeleton()
        historyCollection.hideSkeleton()
    }
}

// MARK: - Action Methods
extension ProfileViewController {
    @objc func onTapMoreSettings() {
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        fpc.isRemovalInteractionEnabled = true
        showMoreSettings()
    }
    
    @objc func seeAllHistoryTapped() {
        let vc = DetailHistoriViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.historyItems = self.historyItems
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onTapGallery() {
        self.pickerImage.allowsEditing = true
        self.pickerImage.delegate = self
        self.pickerImage.sourceType = .photoLibrary
        self.present(self.pickerImage, animated: true, completion: nil)
    }
    
    @objc func onTapCamera() {
        self.pickerImage.allowsEditing = true
        self.pickerImage.delegate = self
        self.pickerImage.sourceType = .camera
        self.present(self.pickerImage, animated: true, completion: nil)
    }
}

// MARK: - Data Binding
extension ProfileViewController {
    func bindData() {
        guard let userID = Firebase.auth.currentUser?.uid else { return }
        profileViewModel.fetchHistory(userID: userID)
        profileViewModel.fetchUserData(userID: userID)
        
        profileViewModel.loadingState.asObservable().subscribe(onNext: {[weak self] loading in guard let self = self else {return}
            switch loading {
            case .loading:
                self.showSkeletonView()
            case .finished:
                self.historyCollection.reloadData()
                self.hideSkeletonView()
            case .failure:
                if !self.isConnected() {
                    ToastManager.shared.showToastOnlyMessage(message: "Please check your internet connection.")
                    self.showErrorView()
                    self.hideSkeletonView()
                }
            }
        }).disposed(by: bag)
        
        profileViewModel.purchaseHistory.asObservable().subscribe(onNext: {[weak self] data in
            guard let  self = self else { return }
            self.historyItems = data
            self.historyCollection.reloadData()
        }).disposed(by: bag)
        
        profileViewModel.name.bind(to: nameText.rx.text).disposed(by: bag)
        
        profileViewModel.phoneNumber.bind(to: phoneNumberText.rx.text).disposed(by: bag)
    }
}

// MARK: - IMAGE PICKER
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image =  info[.editedImage] as? UIImage else {return}
        self.imageChoosen = info
        self.profileImage.image = image
        self.dismiss(animated: true)
        self.uploadToFirebaseStorage(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func uploadToFirebaseStorage(image: UIImage) {
        guard let userID = Firebase.auth.currentUser?.uid else {
            print("Error: User ID is nil.")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            ToastManager.shared.showToastOnlyMessage(message: "Error: Could not convert image to JPEG data.")
            return
        }
        
        let storageRef = Storage.storage().reference()
            .child("user_images_profile")
            .child(userID)
            .child("profile-\(userID).jpeg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                ToastManager.shared.showToastOnlyMessage(message: "Error uploading image: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func getImageFromFirbaseStorage() {
        guard let userID = Firebase.auth.currentUser?.uid else {
            print("Error: User ID is nil.")
            return
        }
        
        let storageRef = Storage.storage().reference()
            .child("user_images_profile")
            .child(userID)
            .child("profile-\(userID).jpeg")
        
        storageRef.downloadURL { (url, error) in
            if let downloadURL = url {
                // Download image data from the URL
                URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        // Update UI on the main thread
                        DispatchQueue.main.async {
                            self.profileImage.image = image
                        }
                    }
                }.resume()
            } else {
                print("Error getting download URL: \(error?.localizedDescription ?? "")")
            }
        }
    }
}

// MARK: - Skeleton View

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, SkeletonCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if historyItems.count > 5 {
            return 5
        }
        return historyItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as! HistoryCollectionViewCell
        let historyItem = historyItems[indexPath.item]
        cell.configureContent(data: historyItem)
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: HistoryCollectionViewCell.self)
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - More Settings Delegate

extension ProfileViewController: MoreSettingsDelegate {
    
    func FloatingPanelToEdit() {
        let vc = EditProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func FloatingPanelToExit() {
        let firebaseAuth = Firebase.auth
        do {
            try firebaseAuth.signOut()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let appDelegate = windowScene.delegate as? SceneDelegate {
                let initialViewController = LoginViewController()
                let navigationController = UINavigationController(rootViewController: initialViewController)
                appDelegate.window?.rootViewController = navigationController
                appDelegate.window?.makeKeyAndVisible()
            }
        } catch let signOutError as NSError {
            ToastManager.shared.showToastOnlyMessage(message: "Failed LogOut \(signOutError)")
        }
    }
    
}

// MARK: - Error Handling
extension ProfileViewController: ErrorHandlingDelegate {
    func showErrorView() {
        guard let errorVC = errorHandlingController else { return }
        
        if !isConnected() {
            errorVC.errorType = .networkError
        } else {
            errorVC.errorType = .emptyDataError
        }
        errorVC.delegate = self
        addChild(errorVC)
        view.addSubview(errorVC.view)
        errorVC.didMove(toParent: self)
    }
    
    func didRefresh() {
        bindData()
        refreshControl.endRefreshing()
    }
    
    func isConnected() -> Bool {
        guard let reachability = try? Reachability() else { return false }
        return reachability.connection != .unavailable
        
    }
}

