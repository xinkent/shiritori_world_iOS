import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sf:ShiritoriFetcher
    var body: some View {
        TabView{
            // 地図画面
            ShiritoriTopView()
                .tabItem{
                    Image(systemName:"mappin.and.ellipse")
                    Text("回答画面")
                }
            // 新着店舗画面
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
