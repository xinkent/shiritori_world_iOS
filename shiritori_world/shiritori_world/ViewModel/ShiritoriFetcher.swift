import SwiftUI

class ShiritoriFetcher: ObservableObject{
    @Published var shiritoriWords:[Shiritori] = [] // UserIDに対応するshiritoriを取得する
    func fetchShiritori(){} // shiritori取得用の関数
}
