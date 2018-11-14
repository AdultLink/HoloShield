using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class RotateAround : MonoBehaviour {
	public Transform pivotPoint;
	public float rotationSpeed = -500f;
	public Vector3 axis;
	// Update is called once per frame

	void Update () {
		transform.RotateAround(pivotPoint.transform.position, axis, rotationSpeed*Time.deltaTime);
	}
}
}