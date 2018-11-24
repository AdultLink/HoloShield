using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class animationController : MonoBehaviour
{
    // Start is called before the first frame update
    public Animator anim;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1)) {
            anim.SetTrigger("activateTransition");
        }

        if (Input.GetKeyDown(KeyCode.Alpha2)) {
            anim.SetTrigger("activateTransition_inv");
        }
    }
}
