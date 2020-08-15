import SwiftUI
import MapKit

struct MapView:UIViewRepresentable{
    @EnvironmentObject var sf:ShiritoriFetcher
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
        if let shiritoriWords = sf.shiritori.shiritoriWords{
            DispatchQueue.global(qos: .utility).async{
                for i in 0..<shiritoriWords.count{
                    let word = shiritoriWords[i]
                    let annotation = MKPointAnnotation()
                    print(word)
                    let centerCoord =  CLLocationCoordinate2D(latitude:word.lat, longitude: word.long)
                    annotation.title = word.word
                    annotation.coordinate = centerCoord
                    
                    // 直線の描画
                    if i > 0{
                        let preWord = shiritoriWords[i-1]
                        let preCoord = CLLocationCoordinate2D(latitude:preWord.lat, longitude: preWord.long)
                        let coordinates = [preCoord , centerCoord]
                        let polyLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
                        uiView.addOverlay(polyLine)
                    }
                    
                    // annotationの描画
                    uiView.addAnnotation(annotation)
                    
                    let span = MKCoordinateSpan(latitudeDelta:1.0, longitudeDelta:1.0)
                    let region = MKCoordinateRegion(center:centerCoord, span:span)
                    uiView.setRegion(region, animated:true)
                    Thread.sleep(forTimeInterval: 1.0)
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent: self)
    }


    class Coordinator: NSObject, MKMapViewDelegate {

        var parent : MapView!
        init(parent: MapView){
            self.parent = parent
        }


        //アノテーションビューを返すメソッド
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            let reuseId = "pin"
//            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
              let pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                //ピンの色を黄色に変更
            pinView.markerTintColor = .red
            pinView.displayPriority = .required
            pinView.clusteringIdentifier = "identifier"
            pinView.collisionMode = .circle
            return pinView
        }
        
        // addOverlay時のメソッド
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let polylineRenderer = MKPolylineRenderer(polyline: polyline)
                polylineRenderer.strokeColor = .red
                polylineRenderer.lineWidth = 2.0
                return polylineRenderer
            }
            return MKOverlayRenderer()
        }
    }
    
}

//struct MapView: UIViewRepresentable {
//    @Binding dynamic var lon:Double
//    @Binding dynamic var lat:Double
//
//    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
//        let view = MKMapView(frame: .zero)
//
//        // 初期位置にピンを追加
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
//        view.addAnnotation(annotation)
//        return view
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
//        print(uiView.annotations)
//
//        // MapAnimationViewの座標が更新された場合、アニメーションで移動させる
//        if uiView.annotations.count > 0{
//            let annotation = uiView.annotations[0] as! MKPointAnnotation
//            let targetPosition = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
//            UIView.animate(withDuration: 4, animations: {
//                annotation.coordinate = targetPosition
//               }, completion: nil)
//        }
//    }
//}
