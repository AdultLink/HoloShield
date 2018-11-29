using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace AdultLink {
	
	[System.Serializable]
	public class CameraPositions : System.Object {
			public string _name;
			[TextArea(0,20)]
			public string _description;
			public Vector3 pos;
			public Vector3 rot;
		
	}

}