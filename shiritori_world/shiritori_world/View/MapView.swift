import SwiftUI
import MapKit

struct MapFrontView: View{
    @ObservedObject var vm:ShiritoriTopViewModel
    @EnvironmentObject var sf:ShiritoriFetcher
    var body: some View{
        VStack{
            Spacer().font(.headline).frame(height:20)
            // タイトル
            HStack{
                Text("移動総距離")
                Text("\(sf.shiritori.totalDistanceKM!)")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Km")
            }
            Spacer().frame(maxHeight:40)
            Text("これまでのしりとり")
            // しりとり選択画面
            SelectShiritoriView(vm:vm)
            // 地図画面
            MapView(vm:vm)
        }
    }
}

struct SelectShiritoriView: View{
    @EnvironmentObject var sf:ShiritoriFetcher
    @ObservedObject var vm:ShiritoriTopViewModel
    var body: some View{
        HStack{
            Spacer().frame(height:30)
            
            VStack{
                // 1つ前選択ボタン
                Button(action:{
                    vm.selection = max(vm.selection - 1, 0)
                }){
                    Image(systemName:"chevron.up.square.fill")
                        .resizable()
                        .frame(width: 30.0, height: 30.0, alignment: .leading)
                }
                Spacer().frame(height:20)
                // 1つ後選択ボタン
                Button(action:{
                    vm.selection = min(vm.selection + 1, sf.shiritori.shiritoriWords!.count-1)
                }){
                    Image(systemName:"chevron.down.square.fill")
                    .resizable()
                    .frame(width: 30.0, height: 30.0, alignment: .leading)
                }
            }
            // しりとり選択Picker
            Picker(selection: $vm.selection, label:Text("しりとり選択")) {
                ForEach(0 ..< self.sf.shiritori.shiritoriWords!.count) {  num in
                    Text("\(self.sf.shiritori.shiritoriWords![num].id).　\(self.sf.shiritori.shiritoriWords![num].word)")
                }
            }.id(vm.id) // 解答追加時に選択肢が更新されるようにする
        }
    }
}

struct MapView:UIViewRepresentable{
    @EnvironmentObject var sf:ShiritoriFetcher
    @ObservedObject var vm:ShiritoriTopViewModel
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
        // 重複して表示されるのを防ぐため、既に追加されているAnnotation, overlayを除去
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
        
        if let shiritoriWords = sf.shiritori.shiritoriWords{
            
            for i in 0...vm.selection{
                let word = shiritoriWords[i]
                // 位置情報み取得のしりとりは表示しない
                if word.lat < 0{
                    continue
                }
                let annotation = MKPointAnnotation()
                
                let centerCoord =  CLLocationCoordinate2D(latitude:word.lat, longitude: word.long)
                // annotation.title = String(word.id)+ ". " + word.word + " " + word.name!
                annotation.title = "\(word.id). \(word.word) (\(word.name!) さん)"
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
                // 常時表示
                uiView.selectedAnnotations = [annotation]

            }
            // 選択されたしりとりに最も近い位置情報取得可能なしりとりに表示位置を合わせる
            var selection = vm.selection
            while (shiritoriWords[selection].lat < -90 || shiritoriWords[selection].long < -180) && (vm.selection > 0){
                selection -= 1
            }
            let word = shiritoriWords[selection]
            let centerCoord =  CLLocationCoordinate2D(latitude:word.lat, longitude: word.long)
            var span = uiView.region.span
            // 初期表示だけ、デフォルトのspanを設定
            if selection == 0{
                span = MKCoordinateSpan(latitudeDelta:1.0, longitudeDelta:1.0)
            }
            let region = MKCoordinateRegion(center:centerCoord, span:span)
            uiView.setRegion(region, animated:true)
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
            // let reuseId = "pin"
//            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
              // let pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //ピンの色を黄色に変更
            // pinView.markerTintColor = .red
            // pinView.displayPriority = .required
            // pinView.clusteringIdentifier = "identifier"
            // pinView.collisionMode = .circle
            
            let pinIdentifier = "PinAnnotationIdentifier"
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
            // アニメーションをつける.
            pinView.animatesDrop = true
            // コールアウトを表示する.
            pinView.canShowCallout = true
            // annotationを設定.
            pinView.annotation = annotation
            
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
