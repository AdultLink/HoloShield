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
        if (Input.GetKeyDown(KeyCode.Q)) {
            anim.SetTrigger("activateTransition");
        }

        if (Input.GetKeyDown(KeyCode.E)) {
            anim.SetTrigger("activateTransition_inv");
        }
    }
}
