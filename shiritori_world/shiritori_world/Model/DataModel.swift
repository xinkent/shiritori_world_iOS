import Foundation
import MapKit

struct User{
    var userID: String
    var name:String
    var age:Int
    var sex:String
    var is_deleted:Bool
}

struct Shiritori{
    var shiritoriID: Int
    var month: String // YYYYMM
    var shiritoriWords: [ShiritoriWord]
}

struct ShiritoriWord:Identifiable{
    var id: Int
    var userID: String
    var lat: Double
    var long: Double
    var address: String?{
        var address = ""
        let location = CLLocation(latitude: 35.711271, longitude:139.797323)// default asakusa
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard
                let placemark = placemarks?.first, error == nil,
                let administrativeArea = placemark.administrativeArea, // 都道府県
                let locality = placemark.locality // 市区町村
        //      let thoroughfare = placemark.thoroughfare, // 地名(丁目)
        //      let subThoroughfare = placemark.subThoroughfare, // 番地
        //      let postalCode = placemark.postalCode, // 郵便番号
        //      let location = placemark.location // 緯度経度情報
            else {
                    return
            }
            print("placemark: \(placemark)")
            print("prefecture: \(administrativeArea)")
            print("locality: \(locality)")

            address = administrativeArea + locality
        }
        return address
    }
    var word: String
}
