using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace AdultLink {
public class TimeController : MonoBehaviour {

	// Use this for initialization
	public RectTransform timeSlider;
	private float timeScaleStep = 0.1f;
	private float timeScale;
	private float initialWidth;
	private float initialHeight;
	public Text timeText;
	void Start () {
		timeScale = Time.timeScale;
		initialWidth = timeSlider.sizeDelta[0];
		initialHeight = timeSlider.sizeDelta[1];
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown(KeyCode.Q)) {
			timeScale -= timeScaleStep;
			setTimescale();
		}

		if (Input.GetKeyDown(KeyCode.E)) {
			timeScale += timeScaleStep;
			setTimescale();
		}
	}

	private void setTimescale() {
		timeScale = Mathf.Clamp(timeScale, 0f, 1f);
		timeSlider.sizeDelta = new Vector2 (timeScale * initialWidth, initialHeight);
		timeText.text = timeScale.ToString("F1");
		Time.timeScale = timeScale;
	}
}
}
