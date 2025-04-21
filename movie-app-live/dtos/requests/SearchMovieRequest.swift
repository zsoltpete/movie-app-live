struct SearchMovieRequest {
    let accessToken: String = Config.bearerToken
    let query: String
    
    func asRequestParams() -> [String: Any] {
        return [
            "query": query
        ]
    }
} 
