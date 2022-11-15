// MIT License
//
// Copyright (c) 2017-2021 Wesley Wickwire and Tokamak contributors
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

public struct TypeInfo {
  public let kind: Kind
  public let name: String
  public let type: Any.Type
  public let mangledName: String
  public let properties: [PropertyInfo]
  public let size: Int
  public let alignment: Int
  public let stride: Int
  public let genericTypes: [Any.Type]

  init(metadata: StructMetadata) {
    kind = metadata.kind
    name = String(describing: metadata.type)
    type = metadata.type
    size = metadata.size
    alignment = metadata.alignment
    stride = metadata.stride
    properties = metadata.properties()
    mangledName = metadata.mangledName()
    genericTypes = Array(metadata.genericArguments())
  }

  public func property(named: String) -> PropertyInfo? {
    properties.first(where: { $0.name == named })
  }
}

/// Creates `TypeInfo` by inspecting `structs`.
///
/// - Important: `nil` is returned if any type other than a `struct` is provided.
public
func typeInfo(of type: Any.Type) -> TypeInfo? {
  guard Kind(type: type) == .struct else {
    return nil
  }

  return StructMetadata(type: type).toTypeInfo()
}

// MARK: dynamic property extraction
extension TypeInfo {
    
    /// Recursively extracts all `SDynamicProperty` conforming properties from the type.
    ///
    /// Recursion is used to find dynamic properties which may be nested.
    ///
    /// Environment values may also be injected during this process.
//    func dynamicProperties(_ environment: inout SEnvironmentValues,
    func dynamicProperties(in source: inout Any) -> [PropertyInfo] {
        // TODO: Need environment.

        var dynamicProps = [PropertyInfo]()
        
        for property in self.properties where property.type is SDynamicProperty.Type {
            dynamicProps.append(property)
            
            guard let propTypeInfo = typeInfo(of: property.type) else { continue }
            
            //            environment.inject(into: &source, prop.type)
            
            var extracted = property.get(from: source)

            // recursively add any dynamic properties to the collection
//            dynamicProps.append(contentsOf: propTypeInfo.dynamicProperties(&environment,
            dynamicProps.append(contentsOf: propTypeInfo.dynamicProperties(in: &extracted))
            
            // cast to dynamic property and update it.
            var extractedDynamicProp = extracted as! SDynamicProperty
            extractedDynamicProp.update()
            property.set(value: extractedDynamicProp, on: &source)
        }
        
        return dynamicProps
    }
}
