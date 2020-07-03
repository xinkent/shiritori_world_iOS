import SwiftUI

struct ShiritoriListView: View {
    @EnvironmentObject var shiritoriFetcher:ShiritoriFetcher
   
    let shiritoriWordList:[ShiritoriWord] = [
        ShiritoriWord(id: 1, order:1,userID:"xinkent",lat:100, long:200, word:"しりとり"),
        ShiritoriWord(id: 2, order:2,userID:"antyuntyun",lat:100, long:200, word:"りんご"),
        ShiritoriWord(id: 3, order:3,userID:"xinkent",lat:100, long:200, word:"ごりら"),
        ShiritoriWord(id: 4, order:4,userID:"antyuntyun",lat:100, long:200, word:"らっぱ"),
    ]
    
    var body: some View {
        List(shiritoriWordList){ shiritoriWord in
            VStack(alignment: .leading){
            Text("順番:\(shiritoriWord.order)")
            .font(.body)
            .padding()
            Text("回答者:\(shiritoriWord.userID)")
            .font(.body)
            .padding()
            // TODO:緯度経度から都道府県
            Text("回答ワード:\(shiritoriWord.word)")
            .font(.body)
            .padding()
            }
        }
    }
}


struct ShiritoriListView_Previews: PreviewProvider {
    static var previews: some View {
        ShiritoriListView()
    }
}
