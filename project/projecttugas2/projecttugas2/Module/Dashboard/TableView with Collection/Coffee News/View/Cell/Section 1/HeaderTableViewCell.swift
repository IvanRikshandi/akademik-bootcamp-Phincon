//
//  HeaderTableViewCell.swift
//  projecttugas2
//
//  Created by Phincon on 24/11/23.
//

import UIKit
import Lottie

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var dailyLbl: UILabel!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var logoViewLottie: LottieAnimationView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        logoAnimate()
        titleNews.text = .localized("titleCoffee")
        dailyLbl.text = .localized("daily")
    }
    
    func logoAnimate() {
        logoViewLottie.animation = LottieAnimation.named("CoffeeAnimat")
        logoViewLottie.loopMode = .autoReverse
        
        logoViewLottie.play()
    }
    
}
