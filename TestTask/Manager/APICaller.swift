//
//  APICaller.swift
//  TestTask
//
//

import Foundation




final class APICaller {
    static let shared = APICaller()
    private init() {}
    
    //call the API
    public func getData(pageCount: Int, completion:@escaping ((Result<[WelcomeModel], Error>) -> ())) {
        createRequest(with:  URL(string: "https://picsum.photos/v2/list?page=\(pageCount)&limit=20" ), type: .GET) { baserequest in
            URLSession.shared.dataTask(with: baserequest) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failetoGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode([WelcomeModel].self, from: data)
                    completion(.success(json))
                }
                catch {
                    completion(.failure(APIError.failetoGetData))
                }
            }.resume()
        }
    }
}


// MARK: - HTTP Error

enum APIError: Error {
    case failetoGetData
}


 // MARK: - HTTP method
enum HTTPMethod: String {
    case GET
    case POST
}

// create a request for the URL
private func createRequest(with url: URL?, type: HTTPMethod ,completion: @escaping (URLRequest) -> ())    {
    guard let apiUrl = url else {
        return
    }
    var request = URLRequest(url: apiUrl)
    request.httpMethod = type.rawValue
    request.timeoutInterval = 30
    completion(request)
}

