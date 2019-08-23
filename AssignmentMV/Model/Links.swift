

import Foundation
struct Links : Codable {
	let selfValue : String?
	let html : String?
	let download : String?

	enum CodingKeys: String, CodingKey {

		case selfValue = "self"
		case html = "html"
		case download = "download"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		selfValue = try values.decodeIfPresent(String.self, forKey: .selfValue)
		html = try values.decodeIfPresent(String.self, forKey: .html)
		download = try values.decodeIfPresent(String.self, forKey: .download)
	}

}
