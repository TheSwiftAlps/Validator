import Infrastructure

func validKeys(list: [String: BaseScenario.Type]) -> String {
    return scenarioList.map { key, value in key }.sorted().joined(separator: ", ")
}

func filterScenarios(chosen: String, list: [String: BaseScenario.Type]) -> [BaseScenario.Type] {
    var scenarios = [BaseScenario.Type]()
    if chosen == "all" {
        for (_, value) in scenarioList {
            scenarios.append(value)
        }
    }
    else {
        if let klass = scenarioList[chosen] {
            scenarios.append(klass)
        }
    }
    return scenarios
}

