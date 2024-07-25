import Foundation

class WeatherXMLParserDelegate: NSObject, XMLParserDelegate {
    var cities: [(String, String, String)] = []  // 都道府県、都市名、ID
    private var currentElement = ""
    private var currentPrefecture: String?
    private var currentCity: String?
    private var currentId: String?
    
    // XMLの開始タグを検出したときに呼び出される
    //ここでは</city>タグや</"title">タグに到達すると呼び出されます。
    //elementNameにはタグの名前が入り、attributeDictにはタグの属性が辞書形式で渡されます。
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "pref" {
            currentPrefecture = attributeDict["title"]
        } else if elementName == "city" {
            currentCity = attributeDict["title"]
            currentId = attributeDict["id"]
        }
    }
    // XMLの終了タグを検出したときに呼び出される
    //ここでは</city>タグに到達すると呼び出されます。
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "city", let prefecture = currentPrefecture, let city = currentCity, let id = currentId {
            cities.append((prefecture, city, id))
        }
    }
    // XMLの解析が完了したときに呼び出される
    func parserDidEndDocument(_ parser: XMLParser) {
        for city in cities {
            print(city)
        }
    }
}
