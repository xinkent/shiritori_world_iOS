import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sf:ShiritoriFetcher
    @ObservedObject var vm = ShiritoriTopViewModel()
    var body: some View {
        TabView{
            // しりとり回答画面
            ShiritoriTopView(vm:vm)
                .tabItem{
                    Image(systemName:"mappin.and.ellipse")
                    Text("回答画面")
                }
            MapFrontView(vm:vm)
                .tabItem{
                    Image(systemName:"mappin.and.ellipse")
                    Text("Map")
            }
            // しりとり履歴画面
            ShiritoriListView()
            .tabItem{
                Image(systemName:"list.bullet")
                Text("しりとり履歴")
            }
        }
        .onAppear(perform:{
            self.sf.fetchUserShiritori()
        })
    }
}
