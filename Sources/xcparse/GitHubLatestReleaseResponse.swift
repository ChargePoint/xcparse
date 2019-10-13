//
//  GitHubLatestReleaseResponse.swift
//  xcparse
//
//  Created by Alexander Botkin on 10/12/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

// Very small subset of https://developer.github.com/v3/repos/releases/
public final class GitHubLatestReleaseResponse: Codable {
    let url: String
    let tag_name: String
    let name: String
    let prerelease: Bool
}
