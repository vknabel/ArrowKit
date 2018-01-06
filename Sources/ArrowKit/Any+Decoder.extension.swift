internal extension Dictionary where Key == String, Value == Any {
  init(from decoder: Decoder) throws {
    var container = try decoder.container(keyedBy: StringCodingKey.self)
    self = try decodeValue(from: &container)
  }
}

internal extension Array where Element == Any {
  init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    self = try decodeUnkeyedValue(from: &container)
  }
}

internal struct StringCodingKey: CodingKey {
  let stringValue: String

  init?(stringValue: String) {
    self.stringValue = stringValue
  }

  init?(intValue: Int) {
    return nil
  }

  var intValue: Int? {
    return nil
  }
}

internal struct IntCodingKey: CodingKey {
  let value: Int

  var stringValue: String {
    return "\(value)"
  }

  init?(stringValue: String) {
    return nil
  }

  init?(intValue: Int) {
    value = intValue
  }

  var intValue: Int? {
    return value
  }
}

internal func decodeDict<K>(forKey key: K, from container: KeyedDecodingContainer<K>) throws -> [String: Any] {
  if container.contains(key) {
    var container = try container.nestedContainer(
      keyedBy: StringCodingKey.self,
      forKey: key
    )
    return try decodeValue(from: &container)
  } else {
    return [:]
  }
}

internal func decodeValue(from container: inout UnkeyedDecodingContainer) throws -> Any {
  if let value = try? container.decode(Bool.self) {
    return value
  } else if let value = try? container.decode(Int.self) {
    return value
  } else if let value = try? container.decode(Double.self) {
    return value
  } else if let value = try? container.decode(String.self) {
    return value
  } else if let value = try? container.decode(Null.self) {
    return value
  } else {
    throw ArrowError.couldNotDecodeValue(container.codingPath, nil)
  }
}

internal func decodeAnyValue<K>(forKey key: K, from container: inout KeyedDecodingContainer<K>) throws -> Any {
  if let value = try? container.decode(Bool.self, forKey: key) {
    return value
  } else if let value = try? container.decode(Int.self, forKey: key) {
    return value
  } else if let value = try? container.decode(Double.self, forKey: key) {
    return value
  } else if let value = try? container.decode(String.self, forKey: key) {
    return value
  } else if let value = try? container.decode(Null.self, forKey: key) {
    return value
  } else {
    throw ArrowError.couldNotDecodeValue(container.codingPath + [key], nil)
  }
}

internal func decodeValue(from container: inout KeyedDecodingContainer<StringCodingKey>) throws -> [String: Any] {
  var dict = [String: Any](minimumCapacity: container.allKeys.count)
  for key in container.allKeys {
    if var keyedContainer = try? container.nestedContainer(keyedBy: StringCodingKey.self, forKey: key) {
      dict[key.stringValue] = try decodeValue(from: &keyedContainer)
    } else if var unkeyedContainer = try? container.nestedUnkeyedContainer(forKey: key) {
        dict[key.stringValue] = try decodeUnkeyedValue(from: &unkeyedContainer)
    } else {
      dict[key.stringValue] = try decodeAnyValue(forKey: key, from: &container)
    }
  }
  return dict
}

internal func decodeUnkeyedValue(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
  var array = [Any]()
    while !container.isAtEnd {
        if var keyedContainer = try? container.nestedContainer(keyedBy: StringCodingKey.self) {
            array.append(try decodeValue(from: &keyedContainer))
        } else if var unkeyedContainer = try? container.nestedUnkeyedContainer() {
            array.append(try decodeUnkeyedValue(from: &unkeyedContainer))
        } else {
            throw ArrowError.couldNotDecodeValue(container.codingPath, nil)
        }
    }
  return array
}
