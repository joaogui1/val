/// A type consraint used to perform type checking or inference.
///
/// A constraint is a predicate over one or multiple types, including type variables, that must be
/// satisfied in order for a program to be well-typed. Constraints also server to infer implicit
/// type information from the structure of the program.
public protocol Constraint {

  /// The cause of the constraint, if known.
  var cause: ConstraintCause? { get set }

  /// Applies `modify` on the types that are part of `self`.
  mutating func modifyTypes(_ modify: (inout Type) -> Void)

  /// Returns whether the constraint depends on the specified variable.
  func depends(on variable: TypeVariable) -> Bool

  /// Hashes the salient features of `element` by feeding them into `hasher`.
  func hash(into hasher: inout Hasher)

  /// Returns whether `self` is equal to `other`.
  func equals<Other: Constraint>(_ other: Other) -> Bool

}

extension Constraint where Self: Equatable {

  public func equals<Other: Constraint>(_ other: Other) -> Bool {
    if let r = other as? Self {
      return self == r
    } else {
      return false
    }
  }

}

/// Creates a subtyping or equality constraint.
func equalityOrSubtypingConstraint(
  _ l: Type,
  _ r: Type,
  because cause: ConstraintCause?
) -> DisjunctionConstraint {
  DisjunctionConstraint(
    [
      .init(constraints: [EqualityConstraint(l, r, because: cause)], penalties: 0),
      .init(constraints: [SubtypingConstraint(l, r, because: cause)], penalties: 1),
    ],
    because: cause)
}