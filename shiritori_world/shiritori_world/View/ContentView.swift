import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sf:ShiritoriFetcher
    var body: some View {
        TabView{
            // しりとり回答画面
            ShiritoriTopView()
                .tabItem{
                    Image(systemName:"mappin.and.ellipse")
                    Text("回答画面")
                }
            MapView()
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
