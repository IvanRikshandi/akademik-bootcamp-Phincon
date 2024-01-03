import UIKit

class OutletCell: UITableViewCell {
    
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var lblHoursWe: UILabel!
    @IBOutlet weak var lblWeekend: UILabel!
    @IBOutlet weak var lblHoursWd: UILabel!
    @IBOutlet weak var lblWeekday: UILabel!
    @IBOutlet weak var lblOpsHours: UILabel!
    @IBOutlet weak var lblDineIn: UILabel!
    @IBOutlet weak var availDineInCircle: UIImageView!
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var availPickupCircle: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.2
        locationContainer.roundCorners(corners: [.bottomLeft, .topRight], radius: 20)
    }
    
    func configureContent(data: Coffeeoutlet) {
        self.titleOutlet.text = data.name
        self.lblAddress.text = data.address
        configureAvailabilityLabel(label: lblPickUp, isAvailable: data.pickupAvailable, circleImageView: availPickupCircle, type: "Pick Up", color: UIColor.red)
        configureAvailabilityLabel(label: lblDineIn, isAvailable: data.dineInAvailable, circleImageView: availDineInCircle, type: "Dine In", color: UIColor.greenSea)
        
        if let weekdaysOperatingHours = parseOperatingHours(data.operatingHours ?? [], for: .mondayFriday),
           let weekendOperatingHours = parseOperatingHours(data.operatingHours ?? [], for: .saturdaySunday) {

            // Weekdays
            lblWeekday.text = Day.mondayFriday.rawValue
            lblHoursWd.text = weekdaysOperatingHours

            // Weekends
            lblWeekend.text = Day.saturdaySunday.rawValue
            lblHoursWe.text = weekendOperatingHours
        } else if let fullweekOperatingHours = parseOperatingHours(data.operatingHours ?? [], for: .mondaySunday) {

            // Full Week (Monday-Sunday)
            lblWeekday.text = Day.mondaySunday.rawValue
            lblHoursWd.text = fullweekOperatingHours
            lblWeekend.isHidden = true
            lblHoursWe.isHidden = true
        }
    }
    
    func configureAvailabilityLabel(label: UILabel, isAvailable: Bool?, circleImageView: UIImageView, type: String, color: UIColor) {
        if let available = isAvailable {
            label.text = available ? type : "Not Available"
            label.isHidden = !available
            circleImageView.isHidden = !available
            circleImageView.tintColor = available ? color : UIColor.gray
        } else {
            // Penanganan jika nilai nil
            label.text = "Not Available"
            label.isHidden = true
            circleImageView.isHidden = true
        }
    }
    
    func parseOperatingHours(_ operatingHours: [OperatingHour], for dayType: Day) -> String? {
        guard let dayOperatingHour = operatingHours.first(where: { $0.day == dayType }) else {
            return nil
        }
        
        let openTime = dayOperatingHour.openTime
        let closeTime = dayOperatingHour.closeTime
        
        return "\(openTime ?? "") - \(closeTime ?? "")"
    }
    
}
