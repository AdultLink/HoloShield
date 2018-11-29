using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToggleNoise : MonoBehaviour
{
    // Start is called before the first frame update
    public Material mat;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.R)) {
            mat.SetFloat("_Sharpennoise", 1f - mat.GetFloat("_Sharpennoise"));
        }
    }
}
