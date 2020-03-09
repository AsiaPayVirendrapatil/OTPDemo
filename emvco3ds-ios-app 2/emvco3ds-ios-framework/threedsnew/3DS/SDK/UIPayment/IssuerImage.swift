
import Foundation

class IssuerImage{

	var extraHigh : String!
	var high : String!
	var medium : String!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]) {
		extraHigh = dictionary["extraHigh"] as? String
		high = dictionary["high"] as? String
		medium = dictionary["medium"] as? String
	}

}
