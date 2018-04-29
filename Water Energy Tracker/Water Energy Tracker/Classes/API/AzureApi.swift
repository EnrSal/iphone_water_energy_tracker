//
//  AzureApi.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/25/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyJSON
import ReachabilitySwift

class AzureApi: NSObject {
    var alamoFireManager : SessionManager? // this line
    
    static let shared: AzureApi = AzureApi()

    let reachability: Reachability?

    private override init() {
        reachability = Reachability()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 90
        configuration.timeoutIntervalForResource = 90
        alamoFireManager = Alamofire.SessionManager(configuration: configuration) // not in this line
    }

    func getNames(req:GenericRequest, completionHandler: @escaping (ServerError?, NamesResponse?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
                let urlString = "https://getnames-returnshare-and-tempshare-functionapp20180315022717.azurewebsites.net/api/Function1?code=UzaoI5rT33DaB8vyepNfzbmHF1fnaaapMtqUKKe7/aZqHEhD0rhmxQ=="
                let json = req.toJSONString(prettyPrint: true)
                
                print("getNames \(json!)")
                
                let url = URL(string: urlString)!
                let jsonData = json!.data(using: .utf8, allowLossyConversion: false)!
                
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
            
                alamoFireManager!.request(request).responseJSON(completionHandler: {
                    
                    response in
                    switch response.result {
                    case .success:
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("json --> \(utf8Text)")
                            let serverResponse:NamesResponse = NamesResponse(JSONString: utf8Text)!
                            completionHandler(nil, serverResponse)
                        } else {
                            completionHandler(ServerError.defaultError, nil)
                        }
                    case .failure:
                        completionHandler(ServerError.defaultError, nil)
                    }
                })
            
        } else {
            completionHandler(ServerError.noInternet, nil)
        }
    }

    func getNamesNoChange(req:GenericRequest, completionHandler: @escaping (ServerError?, NamesResponse?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
            let urlString = "https://getnames-returnshare-tmpshare-nochange-fnapp20180406055208.azurewebsites.net/api/Function1?code=pDcdf2UHwZJlaClx8Qm3XSGBIQLswHDBtLZ9ERAv5AzU35gNo2KhCg=="
            let json = req.toJSONString(prettyPrint: true)
            
            print("getNames \(json!)")
            
            let url = URL(string: urlString)!
            let jsonData = json!.data(using: .utf8, allowLossyConversion: false)!
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            alamoFireManager!.request(request).responseJSON(completionHandler: {
                
                response in
                switch response.result {
                case .success:
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("json --> \(utf8Text)")
                        let serverResponse:NamesResponse = NamesResponse(JSONString: utf8Text)!
                        completionHandler(nil, serverResponse)
                    } else {
                        completionHandler(ServerError.defaultError, nil)
                    }
                case .failure:
                    completionHandler(ServerError.defaultError, nil)
                }
            })
            
        } else {
            completionHandler(ServerError.noInternet, nil)
        }
    }

    func getConfig(req:DeviceConfiguration, completionHandler: @escaping (ServerError?, DeviceConfiguration?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
            let urlString = "https://getconfiguration-withutcname-functionapp20180330114601.azurewebsites.net/api/Function1?code=edTcb8gYVKbbJyN05RvBDaZ1hLIVy0aaz1BHzNFtH4FhuvEAg7fBMQ=="
            let json = req.toJSONString(prettyPrint: true)
            
            print("getNames \(json!)")
            
            let url = URL(string: urlString)!
            let jsonData = json!.data(using: .utf8, allowLossyConversion: false)!
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            alamoFireManager!.request(request).responseJSON(completionHandler: {
                
                response in
                switch response.result {
                case .success:
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("json --> \(utf8Text)")
                        let serverResponse:DeviceConfiguration = DeviceConfiguration(JSONString: utf8Text)!
                        completionHandler(nil, serverResponse)
                    } else {
                        completionHandler(ServerError.defaultError, nil)
                    }
                case .failure:
                    completionHandler(ServerError.defaultError, nil)
                }
            })
            
        } else {
            completionHandler(ServerError.noInternet, nil)
        }
    }
    
    
    
    func getData(req:GetDataRequest, completionHandler: @escaping (ServerError?, GetDataResponse?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
            let urlString = "https://getdatafordiffstypes-basedontimes-withmacid-20180115121539.azurewebsites.net/api/Function2?code=dx0ioMwaz8woHEyA97rffomzOxR5Llqr1KAGU03H5jbdW7MYoXuRqA=="
            let json = req.toJSONString(prettyPrint: true)
            
            print("getNames \(json!)")
            
            let url = URL(string: urlString)!
            let jsonData = json!.data(using: .utf8, allowLossyConversion: false)!
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            alamoFireManager!.request(request).responseJSON(completionHandler: {
                
                response in
                switch response.result {
                case .success:
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("json --> \(utf8Text)")
                        let serverResponse:GetDataResponse = GetDataResponse(JSONString: utf8Text)!
                        completionHandler(nil, serverResponse)
                    } else {
                        completionHandler(ServerError.defaultError, nil)
                    }
                case .failure:
                    completionHandler(ServerError.defaultError, nil)
                }
            })
            
        } else {
            completionHandler(ServerError.noInternet, nil)
        }
    }


}
