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
    
    func toFirestoreMap()->[String:Any]{
        ["order": self.id , "user_id":self.userID, "word":self.word, "lat":self.lat,
         "long":self.long]
    }
}
