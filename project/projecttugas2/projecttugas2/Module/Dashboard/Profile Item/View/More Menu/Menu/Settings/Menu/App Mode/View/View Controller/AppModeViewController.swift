import UIKit
import RxSwift
import RxRelay

class AppModeViewController: UIViewController {

    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var toogleMode: UISwitch!
    @IBOutlet weak var titleModelBL: UILabel!
    
    private var viewModel: AppModeViewModel!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AppModeViewModel()
        observerDarkModeChanges()
        toogleMode.rx.isOn.bind(to: viewModel.darkModeEnabled).disposed(by: bag)
    }
    
    private func observerDarkModeChanges() {
        viewModel.darkModeEnabled.asObservable().subscribe(onNext: {[weak self] isEnabled in
            self?.updateView()
        }).disposed(by: bag)
    }
    
    private func updateView() {
        guard let viewModel = viewModel else { return }
        
        let isDarkModeEnabled = viewModel.darkModeEnabled.value
        
        view.backgroundColor = isDarkModeEnabled ? .black : .white
        titleModelBL.text = isDarkModeEnabled ? "Dark Mode" : "Light Mode"
        titleModelBL.textColor = isDarkModeEnabled ? .white : .black
        backgroundView.backgroundColor = isDarkModeEnabled ? .black : .white
    }
}
