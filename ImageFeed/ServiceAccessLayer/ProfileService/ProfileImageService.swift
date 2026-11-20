import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
struct ProfileImage: Codable {
    let small: String
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private(set) var avatarURL: String?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastUsername != username else {
            return
        }
        task?.cancel()
        lastUsername = username
        guard let token = OAuth2TokenStorage().token else {
            return
        }
        guard let url = URL(string: "\(Constants.defaultBaseURLString)/users/\(username)") else {
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            self?.task = nil
            self?.lastUsername = nil
            switch result {
            case .success(let userResult):
                guard let avatarURL = userResult.profileImage?.small else {
                    completion(.failure(ProfileImageServiceError.invalidRequest))
                    return
                }
                self?.avatarURL = avatarURL
                
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": avatarURL])
                completion(.success(avatarURL))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
enum ProfileImageServiceError: Error {
    case invalidRequest
}
