//
//  AuthServiceProtocol.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation
import UIKit

protocol AuthServiceProtocol {
    func signInWithGoogle(presenting: UIViewController) async throws -> User
}
