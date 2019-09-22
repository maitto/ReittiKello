//  This file was automatically generated and should not be edited.

import Apollo

public final class StopQuery: GraphQLQuery {
  /// query Stop {
  ///   stop(id: "HSL:2161551") {
  ///     __typename
  ///     name
  ///     stoptimesWithoutPatterns {
  ///       __typename
  ///       realtimeDeparture
  ///       departureDelay
  ///       realtime
  ///       headsign
  ///       trip {
  ///         __typename
  ///         route {
  ///           __typename
  ///           shortName
  ///         }
  ///       }
  ///     }
  ///   }
  /// }
  public let operationDefinition =
    "query Stop { stop(id: \"HSL:2161551\") { __typename name stoptimesWithoutPatterns { __typename realtimeDeparture departureDelay realtime headsign trip { __typename route { __typename shortName } } } } }"

  public let operationName = "Stop"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["QueryType"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("stop", arguments: ["id": "HSL:2161551"], type: .object(Stop.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(stop: Stop? = nil) {
      self.init(unsafeResultMap: ["__typename": "QueryType", "stop": stop.flatMap { (value: Stop) -> ResultMap in value.resultMap }])
    }

    /// Get a single stop based on its ID, i.e. value of field `gtfsId` (ID format is `FeedId:StopId`)
    public var stop: Stop? {
      get {
        return (resultMap["stop"] as? ResultMap).flatMap { Stop(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "stop")
      }
    }

    public struct Stop: GraphQLSelectionSet {
      public static let possibleTypes = ["Stop"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("stoptimesWithoutPatterns", type: .list(.object(StoptimesWithoutPattern.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String, stoptimesWithoutPatterns: [StoptimesWithoutPattern?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Stop", "name": name, "stoptimesWithoutPatterns": stoptimesWithoutPatterns.flatMap { (value: [StoptimesWithoutPattern?]) -> [ResultMap?] in value.map { (value: StoptimesWithoutPattern?) -> ResultMap? in value.flatMap { (value: StoptimesWithoutPattern) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Name of the stop, e.g. Pasilan asema
      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      /// Returns list of stoptimes (arrivals and departures) at this stop
      public var stoptimesWithoutPatterns: [StoptimesWithoutPattern?]? {
        get {
          return (resultMap["stoptimesWithoutPatterns"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [StoptimesWithoutPattern?] in value.map { (value: ResultMap?) -> StoptimesWithoutPattern? in value.flatMap { (value: ResultMap) -> StoptimesWithoutPattern in StoptimesWithoutPattern(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [StoptimesWithoutPattern?]) -> [ResultMap?] in value.map { (value: StoptimesWithoutPattern?) -> ResultMap? in value.flatMap { (value: StoptimesWithoutPattern) -> ResultMap in value.resultMap } } }, forKey: "stoptimesWithoutPatterns")
        }
      }

      public struct StoptimesWithoutPattern: GraphQLSelectionSet {
        public static let possibleTypes = ["Stoptime"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("realtimeDeparture", type: .scalar(Int.self)),
          GraphQLField("departureDelay", type: .scalar(Int.self)),
          GraphQLField("realtime", type: .scalar(Bool.self)),
          GraphQLField("headsign", type: .scalar(String.self)),
          GraphQLField("trip", type: .object(Trip.selections)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(realtimeDeparture: Int? = nil, departureDelay: Int? = nil, realtime: Bool? = nil, headsign: String? = nil, trip: Trip? = nil) {
          self.init(unsafeResultMap: ["__typename": "Stoptime", "realtimeDeparture": realtimeDeparture, "departureDelay": departureDelay, "realtime": realtime, "headsign": headsign, "trip": trip.flatMap { (value: Trip) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Realtime prediction of departure time. Format: seconds since midnight of the departure date
        public var realtimeDeparture: Int? {
          get {
            return resultMap["realtimeDeparture"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "realtimeDeparture")
          }
        }

        /// The offset from the scheduled departure time in seconds. Negative values
        /// indicate that the trip is running ahead of schedule
        public var departureDelay: Int? {
          get {
            return resultMap["departureDelay"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "departureDelay")
          }
        }

        /// true, if this stoptime has real-time data available
        public var realtime: Bool? {
          get {
            return resultMap["realtime"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "realtime")
          }
        }

        /// Vehicle headsign of the trip on this stop. Trip headsigns can change during
        /// the trip (e.g. on routes which run on loops), so this value should be used
        /// instead of `tripHeadsign` to display the headsign relevant to the user.
        public var headsign: String? {
          get {
            return resultMap["headsign"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "headsign")
          }
        }

        /// Trip which this stoptime is for
        public var trip: Trip? {
          get {
            return (resultMap["trip"] as? ResultMap).flatMap { Trip(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "trip")
          }
        }

        public struct Trip: GraphQLSelectionSet {
          public static let possibleTypes = ["Trip"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("route", type: .nonNull(.object(Route.selections))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(route: Route) {
            self.init(unsafeResultMap: ["__typename": "Trip", "route": route.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The route the trip is running on
          public var route: Route {
            get {
              return Route(unsafeResultMap: resultMap["route"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "route")
            }
          }

          public struct Route: GraphQLSelectionSet {
            public static let possibleTypes = ["Route"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("shortName", type: .scalar(String.self)),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(shortName: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Route", "shortName": shortName])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Short name of the route, usually a line number, e.g. 550
            public var shortName: String? {
              get {
                return resultMap["shortName"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "shortName")
              }
            }
          }
        }
      }
    }
  }
}
