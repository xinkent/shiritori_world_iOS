import Foundation
import MapKit

struct User{
    var userID: String?
    var name:String?
    var age:Int?
    var sex:String?
    var isDeleted:Bool=false
    var currentShiritoriID: String?
}

struct Shiritori{
    var shiritoriID: String?
    var month: String? // YYYYMM
    var shiritoriWords: [ShiritoriWord]?
}




struct ShiritoriWord:Identifiable{
    var id: Int
    var userID: String
    var name: String?
    var word: String
    var lat: Double
    var long: Double
    var location:CLLocation{
        CLLocation(latitude: self.lat, longitude: self.long)
    }
    var address: String?
    var answerDate: Date
    var answerDateStr:String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy/MM/dd"
        let dateStr = formatter.string(from: self.answerDate)
        return dateStr
    }
    
    func toFirestoreMap()->[String:Any]{
        [
            "order": self.id,
            "user_id": self.userID,
            "name": self.name as Any,
            "word": self.word,
            "lat": self.lat,
            "long": self.long,
            "answer_date": self.answerDate
        ]
    }
}
