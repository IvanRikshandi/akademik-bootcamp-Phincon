import UIKit
import MapKit

class MapsOutlet: UIViewController {
    
    
    @IBOutlet weak var toogleMapView: UIButton!
    @IBOutlet weak var mapOutlet: MKMapView!
    var selectedCoffeeOutlet: Coffeeoutlet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
    }
    
    func configureMap() {
        if let coffeeOutlet = selectedCoffeeOutlet {
            let coordinate = CLLocationCoordinate2D(latitude: coffeeOutlet.latitude ?? 0.0, longitude: coffeeOutlet.longitude ?? 0.0)

            let annotation = MKPointAnnotation()
            annotation.title = coffeeOutlet.name
            annotation.subtitle = coffeeOutlet.address
            annotation.coordinate = coordinate

            mapOutlet.addAnnotation(annotation)

            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapOutlet.setRegion(region, animated: true)
        }
    }
    
    @IBAction func toogleMapView(_ sender: Any) {
        if mapOutlet.mapType == .standard {
            mapOutlet.mapType = .satellite
        } else {
            mapOutlet.mapType = .standard
        }
        
        let title = mapOutlet.mapType == .standard ? "2D" : "3D"
        toogleMapView.setTitle(title, for: .normal)
    }
    
    @IBAction func zoomIn(_ sender: UIButton) {
        var region = mapOutlet.region
        region.span.latitudeDelta *= 0.5
        region.span.longitudeDelta *= 0.5
        mapOutlet.setRegion(region, animated: true)
    }
    
    @IBAction func zoomOut(_ sender: UIButton) {
        var region = mapOutlet.region
        region.span.latitudeDelta *= 2.0
        region.span.longitudeDelta *= 2.0
        mapOutlet.setRegion(region, animated: true)
    }
}
