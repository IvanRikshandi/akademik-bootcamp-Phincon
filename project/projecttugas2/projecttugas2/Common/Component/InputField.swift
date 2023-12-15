//
//  inputField.swift
//  projecttugas2
//
//  Created by Phincon on 31/10/23.
//

import UIKit

class InputField: UIView {
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var subtitleText: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var backTextField: UIView!
    
    // MARK: - Initializer
       override init(frame: CGRect) {
           super.init(frame: frame)
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           configureView()
       }
       
       // MARK: - Functions
       private func configureView() {
           let view = self.loadNib()
           view.frame = self.bounds
           view.backgroundColor = UIColor.white
           self.addSubview(view)
       }

       @IBAction func inputTapTextArea(_ sender: Any) {
           inputTextField.becomeFirstResponder()
       }


       func setup(title: String, placeholder: String) {
           titleText.text = title
           inputTextField.placeholder = placeholder
           inputTextField.layer.cornerRadius = 20
           inputTextField.clipsToBounds = true
       }

    
}
