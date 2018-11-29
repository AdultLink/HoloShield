using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMovement : MonoBehaviour {

	// Use this for initialization
	public float speed = 0.1f;
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKey(KeyCode.D)) {
		transform.Translate(speed,0f,0f);
		}
		if (Input.GetKey(KeyCode.A)) {
		transform.Translate(-speed,0f,0f);
		}
	}
}
