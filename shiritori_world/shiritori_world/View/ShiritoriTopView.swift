import SwiftUI

struct ShiritoriTopView: View{
    @EnvironmentObject var shiritoriFetcher:ShiritoriFetcher
    @ObservedObject var vm = ShiritoriTopViewModel()
    
    var body: some View{
        Text("ShiritoriTopView")
    }
}




//struct ShiritoriTopView: View {
//    @State dynamic var longitude:Double = 139.745451
//    @State dynamic var latitude:Double = 35.658577
//    var targetLongitude:Double = 143.1212
//    var body: some View {
//        VStack{
//            Button(action:{
//                self.move()
//            }){
//                Text("Move")
//            }
//            AnimationMapView(lon:self.$longitude, lat:self.$latitude)
//        }
//    }
//
//    func move(){
//        self.longitude = self.targetLongitude
//    }
//}
