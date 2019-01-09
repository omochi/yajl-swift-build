import XCTest
import yajl

final class yajl_swiftTests: XCTestCase {
    func test1() {
        class Context {
            var events: [String] = []
        }
        
        var callbacks = yajl_callbacks(yajl_null: nil,
                                       yajl_boolean: nil,
                                       yajl_integer: nil,
                                       yajl_double: nil,
                                       yajl_number: nil,
                                       yajl_string: { (context, pstr, len) -> Int32 in
                                        let context = Unmanaged<Context>.fromOpaque(context!).takeUnretainedValue()
                                        let data = Data(bytesNoCopy: UnsafeMutableRawPointer(mutating: pstr!),
                                                        count: len, deallocator: .none)
                                        let str = String(data: data, encoding: .utf8)!
                                        context.events.append("string: \(str)")
                                        return 1
        },
                                       yajl_start_map: { (context) -> Int32 in
                                        let context = Unmanaged<Context>.fromOpaque(context!).takeUnretainedValue()
                                        context.events.append(("map start"))
                                        return 1
        },
                                       yajl_map_key: { (context, pstr, len) -> Int32 in
                                        let context = Unmanaged<Context>.fromOpaque(context!).takeUnretainedValue()
                                        let data = Data(bytesNoCopy: UnsafeMutableRawPointer(mutating: pstr!),
                                                        count: len, deallocator: .none)
                                        let str = String(data: data, encoding: .utf8)!
                                        context.events.append(("key: \(str)"))
                                        return 1
        },
                                       yajl_end_map: { (context) -> Int32 in
                                        let context = Unmanaged<Context>.fromOpaque(context!).takeUnretainedValue()
                                        context.events.append(("map end"))
                                        return 1
        },
                                       yajl_start_array: nil,
                                       yajl_end_array: nil)
        
        let context = Context()
        
        let handle = yajl_alloc(&callbacks, nil,
                                Unmanaged.passUnretained(context).toOpaque())
        
        let json = """
{ "name": "taro" }
"""
        let jsonData = json.data(using: .utf8)!
        
        var st = jsonData.withUnsafeBytes { (json: UnsafePointer<UInt8>) in
            yajl_parse(handle, json, jsonData.count)
        }
        XCTAssertEqual(st, yajl_status_ok)
        
        st = yajl_complete_parse(handle)
        XCTAssertEqual(st, yajl_status_ok)
        
        yajl_free(handle)
        
        XCTAssertEqual(context.events,
                       ["map start",
                        "key: name",
                        "string: taro",
                        "map end"])
    }
}
