//
//  Paste.swift
//  pastebinAPI
//
//  Created by Christian Schneeweiss on 28.11.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import Foundation

class Paste {
    
    static let shared = Paste()
    private static let urlString = "https://pastebin.com/api/api_post.php"
    
    var APIKey = ""
    
    private init() {
        
    }
    
    public struct Parameters {
        public enum Formats: String {
            case Java = "java", Swift = "swift", Cpp = "cpp"
        }
        
        public enum ExpireDate: String {
            case never = "N", tenMinutes = "10M", oneHour = "1H", oneDay = "1D", oneWeek = "1W", twoWeeks = "2W", oneMonth = "1M", sixMonths = "6M", oneYear = "1Y"
        }
        
        let apiKey: String
        let option = "paste"
        let code: String
        let title: String?
        let format: Formats?
        let expire: ExpireDate?
        
        var data: Data? {
            get {
                var params = [
                    "api_dev_key" : apiKey,
                    "api_option" : option,
                    "api_paste_code" : code
                ]
                if let title = title {
                    params["api_paste_name"] = title
                }
                if let format = format {
                    params["api_paste_format"] = format.rawValue
                }
                if let expire = expire {
                    params["api_paste_expire_date"] = expire.rawValue
                }
                guard let data = params.map({ $0.key + "=" + $0.value }).joined(separator: "&").data(using: .utf8) else {
                    return nil
                }
                
                return data
            }
        }
    }
    
    public func post(_ code: String, title: String? = nil, format: Parameters.Formats? = nil, expireIn expire: Parameters.ExpireDate = Parameters.ExpireDate.oneDay, completion: @escaping ((String) -> Void)) {
        let sema = DispatchSemaphore(value: 0)
        let parameters = Parameters(apiKey: APIKey, code: code, title: title, format: format, expire: expire)
        
        guard let url = URL(string: Paste.urlString) else { fatalError("URL error")}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let data = parameters.data else { fatalError("no parameter data")}
        request.httpBody = data
//        print(String(data: data,encoding: .utf8)!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            guard let data = data else { fatalError("no data")}
            let returnString = String(data: data, encoding: .utf8)!
            completion(returnString)
            sema.signal()
        }
        task.resume()
        sema.wait()
    }
    
    public static func postClipboard(withFormat format: String) {
        let clipboard = Tools.getClipboardString()
        Paste.shared.post(clipboard, format: Parameters.Formats.init(rawValue: format.lowercased())) { response in
            print(response)
            if let url = URL(string: response) {
                url.open()
            }
        }
    }
}
