struct ExecutionOptions: Codable {
    let nestedArrow: Bool?
    var shouldPassArrowParameters: Bool {
        return nestedArrow ?? false
    }
}