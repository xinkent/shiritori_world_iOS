import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @State var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:35.658577, longitude:139.745451)
    @State var scale: Double = 0.2
    var locations: [CLLocationCoordinate2D]
        = [CLLocationCoordinate2D(latitude:35.658577, longitude:139.715451),
            CLLocationCoordinate2D(latitude:35.658577, longitude:139.675451),
            CLLocationCoordinate2D(latitude:35.658577, longitude:139.635451)]
           
    var body: some View {
        VStack{
            Button(action:{self.move_location()}){
                Text("Move")
            }
            MapView(center_coord:self.$location, scale:self.$scale)
        }
    }
    
    func move_location(){
        DispatchQueue.global(qos: .utility).async{
            for (i, loc) in self.locations.enumerated(){
                print(i)
                print(loc)
                // self.scale = 0.2 - Double(i+1) * (0.2 - 0.05) / Double(self.locations.count)
                self.location = loc
                Thread.sleep(forTimeInterval: 1.0)
            }
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var center_coord: CLLocationCoordinate2D
    @Binding var scale: Double
    static var prePosition: CLLocationCoordinate2D?
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        view.showsUserLocation = true
        MapView.self.prePosition = self.center_coord
        return view
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        // ピンの追加
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.center_coord
        annotation.title = "しりとり"
        uiView.addAnnotation(annotation)
        
        // 直線の描画
        let coordinates = [MapView.self.prePosition! , self.center_coord]
        let polyLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
        uiView.addOverlay(polyLine)
        
        // Regionの指定
        let span = MKCoordinateSpan(latitudeDelta:self.scale, longitudeDelta:self.scale)
        let region = MKCoordinateRegion(center:self.center_coord, span:span)
        uiView.setRegion(region, animated:true)
        
        MapView.self.prePosition = self.center_coord
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        return MapView.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {

        var parent : MapView!
        init(parent: MapView){
            self.parent = parent
        }

        // annoattionタップ時のメソッド(現在は未設定)
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
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
        
       //アノテーションビューを返すメソッド
        // func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // }
    }
}

