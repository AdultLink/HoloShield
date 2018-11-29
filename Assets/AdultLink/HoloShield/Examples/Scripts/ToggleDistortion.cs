using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToggleDistortion : MonoBehaviour
{
    // Start is called before the first frame update
    public Material mat;
    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F)) {
            mat.SetFloat("_Enabledistortion", 1f - mat.GetFloat("_Enabledistortion"));
        }
    }
}
