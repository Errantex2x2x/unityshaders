using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//[ExecuteInEditMode]
public class CameraReflection : MonoBehaviour
{
    [SerializeField]
    Camera playerCamera;

    [SerializeField]
    GameObject waterPlane; // normal is in y

    Camera reflectionCamera;

	// Use this for initialization
	void Start ()
    {
        reflectionCamera = GetComponent<Camera>();
        reflectionCamera.transform.forward = -GetReflection();
    }

    // Update is called once per frame
    void Update () {
        Vector3 r = playerCamera.transform.forward; //ray
        Vector3 n = waterPlane.transform.up; //normal

        Vector3 reflection = GetReflection();
        reflectionCamera.transform.LookAt(reflectionCamera.transform.position -reflection);

        //float currentRotation = Vector3.Dot(r, waterPlane.transform.forward) * 90f + 90f;
        //reflectionCamera.transform.RotateAround(waterPlane.transform.position, waterPlane.transform.up, currentRotation - rotationAngle);
        // rotationAngle = currentRotation;
    }

    //http://paulbourke.net/geometry/reflected/
    Vector3 GetReflection()
    {
        Vector3 r = playerCamera.transform.forward; //ray
        Vector3 n = waterPlane.transform.up; //normal

        //http://paulbourke.net/geometry/reflected/
        return -r - 2 * n * (Vector3.Dot(-r, n));
    }

    float rotationAngle = 0;
}
