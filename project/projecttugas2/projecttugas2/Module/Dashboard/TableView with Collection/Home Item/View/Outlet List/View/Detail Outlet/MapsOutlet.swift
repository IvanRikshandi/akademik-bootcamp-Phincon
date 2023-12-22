import UIKit
import MapKit

class MapsOutlet: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var toogleMapView: UIButton!
    @IBOutlet weak var mapOutlet: MKMapView!
    var selectedCoffeeOutlet: Coffeeoutlet?
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    let initialCoordinate = CLLocation(latitude: -6.189495, longitude: 106.6338131)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
        mapOutlet.delegate = self // Set the delegate
    }
    
    func configureMap() {
        if let coffeeOutlet = selectedCoffeeOutlet {
            let coordinate = CLLocationCoordinate2D(latitude: coffeeOutlet.latitude ?? 0.0, longitude: coffeeOutlet.longitude ?? 0.0)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            
            annotation.title = coffeeOutlet.name
            annotation.subtitle = coffeeOutlet.address
            annotation.coordinate = coordinate
            
            mapOutlet.addAnnotation(annotation)
            
            mapOutlet.setRegion(region, animated: true)
            
            getDirections(destinationCoordinate: coordinate)
        }
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapOutlet.showsUserLocation = true
    }
    
    func getDirections(destinationCoordinate: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: initialCoordinate.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] (response, error) in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapOutlet.addOverlay(route.polyline)
                self.mapOutlet.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
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

extension MapsOutlet: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
}
