using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotator : MonoBehaviour {

    [SerializeField]
    float speed = 4;
    float currentRotationX;
    float currentRotationY;

    // Use this for initialization
    void Start () {
		
	}

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButton(0))
        {
            if (Input.GetAxis("Mouse X") < 0)
                currentRotationX = speed;
            if (Input.GetAxis("Mouse X") > 0)
                currentRotationX = -speed;
            if (Input.GetAxis("Mouse Y") < 0)
                currentRotationY = speed;
            if (Input.GetAxis("Mouse Y") > 0)
                currentRotationY = -speed;
        }
        transform.Rotate(Vector3.up * currentRotationX);
        //transform.Rotate(-Vector3.right * currentRotationY);

        currentRotationX = Mathf.Lerp(currentRotationX, 0, Time.deltaTime );
        currentRotationY = Mathf.Lerp(currentRotationY, 0, Time.deltaTime );
    }
}
