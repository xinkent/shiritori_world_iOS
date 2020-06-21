import SwiftUI

struct ShiritoriTopView: View{
    @EnvironmentObject var shiritoriFetcher:ShiritoriFetcher
    @ObservedObject var vm = ShiritoriTopViewModel()
    @State var longitude = 139.745451
    @State var latitude = 35.658577
    
    var body: some View{
        VStack{
            ShiritoriAnswerView(vm:self.vm)
            MapView(lon:self.$longitude, lat:self.$latitude)
        }
    }
}


struct ShiritoriAnswerView:View{
    @ObservedObject var vm:ShiritoriTopViewModel
    var body: some View{
        VStack{
            Spacer().frame(height:50)
            Text("現在のワード")
                .font(.title)
                .background(Color.gray)
                .foregroundColor(Color.white)
            Text("りんご")
            Spacer().frame(height:50)
            if(vm.isTurn){
                TextField("解答入力",text: $vm.word )
            }
            Toggle("手番切り替え(開発用)", isOn: $vm.isTurn)
            Spacer()
        }.frame(maxWidth:.infinity)
            .frame(height:300)
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
