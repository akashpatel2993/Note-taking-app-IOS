//
//  ImageMapViewController.swift
//  MyNotes
//
//  Created by jay on 2016-11-29.
//  Copyright © 2016 jay. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ImageMapViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    var coordinates:CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinates=CLLocation(latitude: 43.768802, longitude: -79.347591)
        centerMapOnLocation(location: coordinates!)
        let mk=MKPointAnnotation()
        mk.title="sample"
        mk.coordinate=CLLocationCoordinate2D(latitude: (self.coordinates?.coordinate.latitude)!, longitude: (self.coordinates?.coordinate.longitude)!)
        self.mapView.addAnnotation(mk)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    //    {
    //        if let annotation = annotation as? MKAnnotation {
    //            let identifier = "pin"
    //            var view: MKPinAnnotationView
    //            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    //                as? MKPinAnnotationView { // 2
    //                dequeuedView.annotation = annotation
    //                view = dequeuedView
    //            } else {
    //                // 3
    //                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    //                view.canShowCallout = true
    //                view.calloutOffset = CGPoint(x: -5, y: 5)
    //                view.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
    //            }
    //            return view
    //        }
    //        return nil
    //    }
    
    
}
