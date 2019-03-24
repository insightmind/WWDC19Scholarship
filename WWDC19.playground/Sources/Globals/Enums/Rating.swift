import Foundation

/// The rating of a LevelCompletion
///
/// - empty: No stars
/// - single: One star
/// - double: Two stars
/// - triple: Three stars
public enum Rating: Int {
    case empty = 0
    case single = 1
    case double = 2
    case triple = 3
}
