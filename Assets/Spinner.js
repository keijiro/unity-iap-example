function Update() {
	transform.localRotation =
		Quaternion.AngleAxis(33.0 * Time.deltaTime, Vector3.up) *
		Quaternion.AngleAxis(7.0 * Time.deltaTime, Vector3.right) *
		transform.localRotation;
}
