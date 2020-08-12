import SwiftUI
import MapKit

struct MapView:UIViewRepresentable{
    @EnvironmentObject var sf:ShiritoriFetcher
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let view = MKMapView(frame: .zero)
        return view
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
        if let shiritori_words = sf.shiritori.shiritoriWords{
            for word in shiritori_words{
                let annotation = MKPointAnnotation()
                print(word)
                annotation.title = word.word
                annotation.coordinate = CLLocationCoordinate2D(latitude:word.lat, longitude: word.long)
                uiView.addAnnotation(annotation)
            }
            //            let annotation1 = MKPointAnnotation()
            //            annotation1.coordinate = CLLocationCoordinate2D(latitude:35.658581, longitude: 139.745433)
            //            uiView.addAnnotation(annotation1)
            //
            //            let annotation2 = MKPointAnnotation()
            //            annotation2.coordinate = CLLocationCoordinate2D(latitude:35.687647, longitude: 138.788853)
            //            uiView.addAnnotation(annotation2)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent: self)
    }
}

extension MapView{
    class Coordinator: NSObject, MKMapViewDelegate {

        var parent : MapView!
        init(parent: MapView){
            self.parent = parent
        }


        //アノテーションビューを返すメソッド
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           //アノテーションビューを生成する。
            let reuseId = "pin"
            let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
            //アノテーションビューに色を設定する。
            pinView?.markerTintColor = .blue
            //吹き出しの表示をONにする。
            pinView!.canShowCallout = true
            pinView?.displayPriority = .defaultHigh
            pinView?.clusteringIdentifier = "identifier"
            return pinView
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
