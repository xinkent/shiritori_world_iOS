import SwiftUI
import Firebase

class ShiritoriTopViewModel: ObservableObject {
    @Published var word: String = ""
    @Published var beforeSent: Bool = false
    @Published var isSent: Bool = false
    @Published var isError:Bool = false
    @Published var selection: Int = 0 {
        willSet { // selectionが変更された時、選択肢そのものが更新されるようにする
            id = UUID()
        }
    }
    @Published var id: UUID = UUID()
    let defaultLon = -999.0
    let defaultLat = -999.0
    let collection_name = "shiritori"
    
    let db = Firestore.firestore()
    func send_answer(sf: ShiritoriFetcher, lm: LocationManager, name:String, word:String){
        
        var shiritoriList:[ShiritoriWord] = sf.shiritori.shiritoriWords ?? []
        
        let latitude = lm.location?.latitude ?? self.defaultLon
        let longitude = lm.location?.longitude ?? self.defaultLat
        shiritoriList.append(
            ShiritoriWord(
                id:shiritoriList.count + 1,
                userID:sf.user.userID!,
                name:name,
                word:word,
                lat:latitude,
                long:longitude,
                answerDate: Date()
                
            )
        )
        // TODO: monthの自動取得
        db.collection(self.collection_name).document(sf.user.currentShiritoriID!).setData(
            [
                "month":"202006",
                "shiritori_id":sf.user.currentShiritoriID!,
                "shiritori_word": shiritoriList.map{$0.toFirestoreMap()}
            ]
            ,merge:false
        ){
            err in
            if err != nil{
                self.isError = true
            } else {
                self.isSent = true
                // UserDefaultに名前を保存
                UserDefaults.standard.set(name, forKey: "username")
            }
        }
    }
    
    func beforeSend(){
        self.beforeSent = true
    }
    
    func isHiraganaOrKatakana(word:String) -> Bool{
        let regex = "^([ぁ-ゞ]|[ァ-ヾ])+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: word)
    }
    
    func isBlank(word:String) -> Bool{
        word == ""
    }
    
    func isContainedBlank(word:String) -> Bool{
        let regex = ".*\\s.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: word)
    }
    
    func isSequentialWord(currentWord:String, prevWord:String) -> Bool{
        prevWord.toHiragana().suffix(1) == currentWord.toHiragana().prefix(1)
    }
    
    func isEndN(word:String) -> Bool{
        word.toHiragana().hasSuffix("ん")
    }
    
    func isEndHiphen(word:String) -> Bool{
        word.toHiragana().hasSuffix("ー")
    }
    
    func isValidLength(word:String) -> Bool{
        word.count <= 12
    }
    
    func validate(currentWord:String, prevWord:String, name:String) -> (isValid:Bool, message:String){
        if self.isBlank(word: currentWord){
            return (false, "")
        } else if self.isContainedBlank(word: currentWord){
            return (false, "文字中に空白が含まれています")
        } else if !self.isHiraganaOrKatakana(word: currentWord){
            return (false, "入力はひらがな・カタカナにしてください")
        } else if !self.isSequentialWord(currentWord:currentWord, prevWord:prevWord){
            return (false, "しりとりしてください")
        } else if self.isEndHiphen(word: currentWord){
            return (false, "-で終わらないでください")
        } else if !self.isValidLength(word: currentWord){
            return (false, "文字数は12文字までです")
        } else if self.isEndN(word: currentWord){
            return (false, "しりとりを終わらせないでください")
        } else if self.isBlank(word: name){
            return (false, "回答者名を入力してください")
        }
        else {
            return(true, "")
        }
    }
}


extension String {
    func toKatakana() -> String {
        var str = ""

        for c in unicodeScalars {
            if c.value >= 0x3041 && c.value <= 0x3096 {
                str += String(describing: UnicodeScalar(c.value + 96)!)
            } else {
                str += String(c)
            }
        }

        return str
    }

    func toHiragana() -> String {
        var str = ""

        for c in unicodeScalars {
            if c.value >= 0x30A1 && c.value <= 0x30F6 {
                str += String(describing: UnicodeScalar(c.value - 96)!)
            } else {
                str += String(c)
            }
        }

        return str
    }
    
    func get_order(sf: ShiritoriFetcher)->Int{
        return (sf.shiritori.shiritoriWords?.count ?? 0  + 1)
    }
}
