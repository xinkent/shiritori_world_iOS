import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sf:ShiritoriFetcher
    @ObservedObject var topVm = ShiritoriTopViewModel()
    @ObservedObject var mapVm = MapViewModel()
    @ObservedObject var listVm = ShiritoriListViewModel()
    @ObservedObject var contentVm = ContentViewModel()
    var visit = UserDefaults.standard.bool(forKey: "visit")
    
    var body: some View {
        if self.visit || contentVm.accepted{
            TabView{
                // しりとり回答画面
                ShiritoriTopView(vm:topVm)
                    .tabItem{
                        Image(systemName:"paperplane")
                        Text("回答画面")
                    }
                MapFrontView(vm:mapVm)
                    .tabItem{
                        Image(systemName:"mappin.and.ellipse")
                        Text("Map")
                }
                // しりとり履歴画面
                ShiritoriListView(vm:listVm)
                    .tabItem{
                        Image(systemName:"list.bullet")
                        Text("しりとり履歴")
                    }
                
                // 設定画面
                SettingView()
                    .tabItem{
                        Image(systemName:"ellipsis")
                        Text("設定")
                    }
            }
            .onAppear(perform:{
                self.sf.fetchUserShiritori()
            })
        } else{
            FirstView(vm:contentVm)
        }
    }
}
