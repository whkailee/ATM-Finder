//
//  MapViewController.swift
//  ATMFinder
//
//  Created by Steven Li on 21/07/16.
//  Copyright © 2016 Xinc. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private var cachedLocations = Array<Location>();
    private var mapClusterController : CCHMapClusterController?
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Map"
        mapClusterController = CCHMapClusterController(mapView: mapView)
        mapView.delegate = self
        
        /*
        self.mapClusterer = [[CCHCenterOfMassMapClusterer alloc] init];
        self.mapClusterController.clusterer = self.mapClusterer;
        self.mapAnimator = [[CCHFadeInOutMapAnimator alloc] init];
        self.mapClusterController.animator = self.mapAnimator;
        self.mapClusterController.maxZoomLevelForClustering = 16;
        self.mapClusterController.minUniqueLocationsForClustering = 3;
 */
        mapClusterController?.maxZoomLevelForClustering = 16
        mapClusterController?.minUniqueLocationsForClustering = 3
        
        getLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocations() {
        
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: "https://api.asb.co.nz/public/v1/locations?apikey=l7xxe3e8e66f6fdb47ac830eed54ca875f37&view=geosummary")
        request.HTTPMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let data = data {
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                    
                    let objects: NSArray = json.valueForKey("value") as! NSArray
                    
                    for obj: AnyObject in objects {
                        if let location = obj as? NSDictionary {
                            if let type = location.objectForKey("type") as? NSString {
                                if (type == "atm") {
                                    let atm: ATM = ATM()
                                    atm.setValuesForKeysWithDictionary(location as! [String : AnyObject])
                                    self.cachedLocations.append(atm)
                                    self.mapClusterController?.addAnnotations([atm], withCompletionHandler: nil)
                                }
                                else if (type == "branch") {
                                    let branch: Branch = Branch()
                                    branch.setValuesForKeysWithDictionary(location as! [String : AnyObject])
                                    self.cachedLocations.append(branch)
                                    self.mapClusterController?.addAnnotations([branch], withCompletionHandler: nil)
                                }
                            }
                        }
                    }
                    
                }
                catch {
                    
                }
            }
        }.resume()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let clusterAnnotation = annotation as? CCHMapClusterAnnotation {
            
            var clusterAnnotationView : ClusterAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("clusterAnnotation") as? ClusterAnnotationView
            if (clusterAnnotationView != nil && clusterAnnotation.annotations.count > 0) {
                clusterAnnotationView?.annotation = annotation
            }
            else {
                clusterAnnotationView = ClusterAnnotationView(annotation: annotation, reuseIdentifier: "clusterAnnotation")
                clusterAnnotationView?.canShowCallout = true
            }
            
            clusterAnnotationView?.count = UInt(clusterAnnotation.annotations.count)
            clusterAnnotationView?.uniqueLocation = clusterAnnotation.isUniqueLocation()
            
            
            if (clusterAnnotation.annotations.count == 1) {
                clusterAnnotationView?.isAtm = clusterAnnotation.annotations.first!.isKindOfClass(ATM)
                
                let calloutButton = UIButton(type: UIButtonType.DetailDisclosure)
                calloutButton.tintColor = UIColor.yellowColor()
                clusterAnnotationView?.rightCalloutAccessoryView = calloutButton
            }
            else {
                clusterAnnotationView?.rightCalloutAccessoryView = nil
            }
            
            return clusterAnnotationView
        }
        else {
            return nil
        }
    }
    
    /*
     - (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
     {
     MKAnnotationView *annotationView;
     
     if ([annotation isKindOfClass:CCHMapClusterAnnotation.class]) {
     ...
     annotationView = clusterAnnotationView;
     }
     
     return annotationView;
     }
     
     */
}
