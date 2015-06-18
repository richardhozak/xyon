function containsProperty(object, propertyName) {
	for (var property in object) {
		if (property == propertyName) {
			return true
		}
	}

	return false
}

function findChild(parentObject, childName) {
	for (var index in parentObject.children) {
		var child = parentObject.children[index]
		if (child.objectName == childName) {
			return child
		}
	}

	return null
}

function setIfNotNull(object, propertyName, value) {
	if (object != null) {
		object[propertyName] = value
	}
}

function callIfNotNull(object, methodName) {
	if (object != null) {
		object[methodName]()
	}
}
