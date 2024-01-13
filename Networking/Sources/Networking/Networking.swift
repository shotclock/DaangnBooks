import Foundation

public protocol Networking {
    func request(method: HTTPRequestMethods,
                 url: String,
                 parameter: NetworkingParameter?,
                 timeoutInterval: TimeInterval) async -> Result<Data, NetworkError>
}

public extension Networking {
    func request(method: HTTPRequestMethods,
                 url: String,
                 parameter: NetworkingParameter?,
                 timeoutInterval: TimeInterval = 3.0) async -> Result<Data, NetworkError> {
        await request(method: method,
                      url: url,
                      parameter: parameter,
                      timeoutInterval: timeoutInterval)
    }
}

struct NetworkingImplement: Networking {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func request(method: HTTPRequestMethods,
                 url: String,
                 parameter: NetworkingParameter?,
                 timeoutInterval: TimeInterval) async -> Result<Data, NetworkError> {
        var urlComponent = URLComponents(string: url)
        if method == .get,
           let parameter {
            urlComponent?.queryItems = parameter.toDictionary().map {
                .init(name: $0, value: $1 as? String)
            }
        }
        
        guard let url = urlComponent?.url else {
            return .failure(.urlComponentFailure)
        }
        
        var request = URLRequest(url: url,
                                 timeoutInterval: timeoutInterval)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        if method == .post,
           let parameter {
            request.httpBody = parameter.toData()
        }
        
        do {
            let result = try await urlSession.data(for: request)
            guard let httpResponse = result.1 as? HTTPURLResponse else {
                return .failure(.responseValidationFailure)
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                return .success(result.0)
            default:
                return .failure(.httpError(code: httpResponse.statusCode))
            }
        } catch {
            guard let error = error as? URLError else {
                return .failure(.unspecified(description: error.localizedDescription))
            }
            
            return .failure(.urlError(error: error))
        }
    }
}
