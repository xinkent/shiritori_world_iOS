import SwiftUI
import MapKit

struct MapAnimationView: View {
    @State dynamic var longitude:Double = 139.745451
    @State dynamic var latitude:Double = 35.658577
    var targetLongitude:Double = 143.1212
    var body: some View {
        VStack{
            Button(action:{
                self.move()
            }){
                Text("Move")
            }
            AnimationMapView(lon:self.$longitude, lat:self.$latitude)
        }
    }
    
    func move(){
        self.longitude = self.targetLongitude
    }
}


struct AnimationMapView: UIViewRepresentable {
    @Binding dynamic var lon:Double
    @Binding dynamic var lat:Double
    
    func makeUIView(context: UIViewRepresentableContext<AnimationMapView>) -> MKMapView {
        let view = MKMapView(frame: .zero)
        
        // 初期位置にピンを追加
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
        view.addAnnotation(annotation)
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<AnimationMapView>) {
        print(uiView.annotations)
        
        // MapAnimationViewの座標が更新された場合、アニメーションで移動させる
        if uiView.annotations.count > 0{
            let annotation = uiView.annotations[0] as! MKPointAnnotation
            let targetPosition = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
            UIView.animate(withDuration: 4, animations: {
                annotation.coordinate = targetPosition
               }, completion: nil)
        }
    }
}
