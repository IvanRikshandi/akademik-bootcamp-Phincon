//
//  ViewController.swift
//  latihan_week2_hari2
//
//  Created by Phincon on 31/10/23.
//

import UIKit
import StepSlider

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerViewClock: UIPickerView!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var viewSlider: StepSlider!
    @IBOutlet weak var toogleSwitch: UISwitch!
    
//    var selectedHour: [String] = []
//    let selectedMinute = Array(0...59).map {String(format: "%02d", $0)}
//    let amPm = ["AM", "PM"]
    let label = ["1", "2", "3", "4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewClock.dataSource = self
        pickerViewClock.delegate = self
        stepSliderFunc()
        switchButtonFunc()
    }
    
    // Logic buat stepSlider
    func stepSliderFunc(){
        // Konfigurasi StepSlider
        
        viewSlider.trackHeight = 4.0
        viewSlider.labels = label
        viewSlider.labelColor = UIColor.black
        viewSlider.sliderCircleRadius = 12.0
        viewSlider.sliderCircleColor = UIColor.blue

        // Optional: Set the initial value
        viewSlider.index = 0 // Nilai awal

               // Tambahkan StepSlider ke tampilan
               view.addSubview(viewSlider)
        
        // Add a target to track value changes
                viewSlider.addTarget(self, action: #selector(stepSliderValueChanged), for: .valueChanged)
    }
    @objc func stepSliderValueChanged(){
        let selectedValue = viewSlider.index
        labelValue.text = "level :" + label[Int(selectedValue)]
    }
    
    // Function Switch Button
    func switchButtonFunc() {
        toogleSwitch.isOn = true
    }
    
    
    @IBAction func toogleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            labelValue.text = "Sudah ON"
        }
        else{
            labelValue.text = "Sudah OFF"
        }
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { // Hours
            return 12
        } else if component == 1 { // Minutes
            return 60
        } else { // AM/PM
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 { // Hours
            return "\(row + 1)"
        } else if component == 1 { // Minutes
            return String(format: "%02d", row)
        } else { // AM/PM
            return (row == 0) ? "AM" : "PM"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHour = pickerView.selectedRow(inComponent: 0) + 1
        let selectedMinute = pickerView.selectedRow(inComponent: 1)
        let amPm = (pickerView.selectedRow(inComponent: 2) == 0) ? "AM" : "PM"
        
        labelValue.text = String(format: "%02d:%02d %@", selectedHour, selectedMinute, amPm)
    }

    
    
}



