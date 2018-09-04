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
    
    func getNamesByShareNum(req:GenericRequest, completionHandler: @escaping (ServerError?, NamesResponse?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
            let urlString = "https://getnames-stype-macid-from-sharenumber-app20180110055554.azurewebsites.net/api/Function1?code=aOOfcQbfPMfS92jXsotHyzXBGBzeKjq8FalabYXJ0tF6x1p6MCYQgA=="
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

    func setNames(req:GenericRequest, completionHandler: @escaping (ServerError?, GenericResponse?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
            let urlString = "https://setname-for-a-particular-mac-idfunctionapp20180106123202.azurewebsites.net/api/Function1?code=yjkdGag18kRwGZvgH5z23l/PhAk05pKuaC1wYkFIczFu72ahbdXwmQ=="
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
                        let serverResponse:GenericResponse = GenericResponse(JSONString: utf8Text)!
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
            
            let urlString = "https://getconfiguration-allunits-functionapp20180725062359.azurewebsites.net/api/Function1?code=r7quqa/ybf78iSy3gHiEWW5oIAVx2nXGb8K33sqVpMDRFl37Vp6MTQ=="
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
                        print("getConfig --> \(utf8Text)")
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
            
            let urlString = "https://getdatafordiffstypes-basedontimes-withmacid-morewaterdata.azurewebsites.net/api/Function2?code=WKCst/HUBs2qgVzxcnuJMTIDc0QBWHU04J2BTtxDhCeqf7rDV/L8Kw=="
            let json = req.toJSONString(prettyPrint: true)
            
            print("==== GET DATA ==== \(json!)")
            
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
                        print("GET DATA --> \(utf8Text)")
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

    
    func getKwhHistorical(req:HistoricalKwhRequest, completionHandler: @escaping (ServerError?, KwhResponse?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
            let urlString = "https://gethistorical-kwh-basedon-id-date-functionapp20180117120503.azurewebsites.net/api/Function1?code=JAEcNGsascKsgr3WYGY3NFs/hto3Jl4Mvb0ljhl31SlM1qljGLXiyA=="
            let json = req.toJSONString(prettyPrint: true)
            
            print("getKwhHistorical \(json!)")
            
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
                        let serverResponse:KwhResponse = KwhResponse(JSONString: utf8Text)!
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

    func getKwh(req:GenericRequest, completionHandler: @escaping (ServerError?, KwhResponse?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
            let urlString = "https://get-kwh-for-id-functionapp20180105042228.azurewebsites.net/api/Function1?code=b5t1lxp8eup5klYWMS1ItTWH4Rz4igmTWEFR7XQF7Hnk9tqP7S8nug=="
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
                        let serverResponse:KwhResponse = KwhResponse(JSONString: utf8Text)!
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

    func setConfig(req:DeviceConfiguration, completionHandler: @escaping (ServerError?, GenericResponse?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
            let urlString = "https://setconfiguration-allunits-functionapp20180725063131.azurewebsites.net/api/Function1?code=VqxVdhuEd6bOACeLjhSwPhuppz2hIKoVMxLQL5utbLFiG68zynirvg=="
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
                        let serverResponse:GenericResponse = GenericResponse(JSONString: utf8Text)!
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

    func getNotifications(req:NotificationsRequest, completionHandler: @escaping (ServerError?, NotificationsResponse?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
            let urlString = "https://getnotificationsbydevicename-functionapp20180317105010.azurewebsites.net/api/Function1?code=XPX0oJl3J6VaNkYUprz6xhyqO2DPnC3Txaaar14agh0pkUuEDx83pA=="
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
                        let serverResponse:NotificationsResponse = NotificationsResponse(JSONString: utf8Text)!
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

    func sendCommand(req:SendCommandRequest, completionHandler: @escaping (ServerError?, GenericResponse?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
            let urlString = "https://sendcommandtodevice-functionapp20180320045223.azurewebsites.net/api/Function1?code=Q4PfiFhPe/xQpEs1i85f/XZX4lfdobek5bZI4Cs7G22YmFV3ee7otw=="
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
                        let serverResponse:GenericResponse = GenericResponse(JSONString: utf8Text)!
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

    func calculateHistorical(req:CalculateHistoricalRequest, completionHandler: @escaping (ServerError?, CalculateHistoricalResponse?) -> Void) {
        if let reachability = reachability, reachability.isReachable {
            
            let urlString = "https://gethistoricalfromto-kwh-functionapp201803150112233.azurewebsites.net/api/Function1?code=WzdPHsawrcQip9vkbokNK8uGAdDJLCANDt3jN8atgittewAaXVatFw=="
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
                        let serverResponse:CalculateHistoricalResponse = CalculateHistoricalResponse(JSONString: utf8Text)!
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
