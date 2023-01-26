import Core

/// A C++ `do`-`while` statement
struct CXXDoWhileStmt: CXXRepresentable {

  /// The statement to be executed as part of the loop.
  let body: CXXRepresentable

  /// The expression to be tested at the end of the loop.
  let condition: CXXRepresentable

  /// The original node in Val AST.
  /// This node can be of any type.
  let original: AnyNodeID.TypedNode?

  func writeCode<Target: TextOutputStream>(into target: inout Target) {
    target.write("do ")
    body.writeCode(into: &target)
    target.write("while ( ")
    condition.writeCode(into: &target)
    target.write(" );\n")
  }

}