using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMovements : MonoBehaviour
{
    Vector3 oldMousePosition = Vector3.zero;

    [SerializeField]
    [Range(0.1f, 1.0f)]
    float RotationSpeed = 0.3f;

    [SerializeField]
    [Range(0.1f, 1.0f)]
    float MovementSpeed = 0.3f;

    bool active = false;

    void Update()
    {
        if (Input.mousePresent)
        {
            bool bMouseOverViewport = Camera.main.pixelRect.Contains(Input.mousePosition);

            if (bMouseOverViewport)
            {
                // Right mouse button
                if (Input.GetMouseButton(1))
                {
                    if (oldMousePosition != Vector3.zero)
                    {
                        if (!active)
                            active = true;
                        else
                        {
                            Vector3 mouseDelta = Input.mousePosition - oldMousePosition;
                            transform.Rotate(new Vector3(0.0f, mouseDelta.x, 0.0f) * RotationSpeed, Space.World);
                            transform.Rotate(new Vector3(-mouseDelta.y, 0.0f, 0.0f) * RotationSpeed);

                            transform.Translate(new Vector3(
                                Input.GetAxis("Horizontal"),
                                (Input.GetKey(KeyCode.E) ? 1 : 0) + (Input.GetKey(KeyCode.Q) ? -1 : 0),
                                Input.GetAxis("Vertical")
                                ) * MovementSpeed);
                        }

                    }
                }
                else
                    active = false;

                oldMousePosition = Input.mousePosition;

                if (Input.mouseScrollDelta.y != 0.0f)
                {
                    MovementSpeed += (Input.mouseScrollDelta.y / 30.0f);
                }

                MovementSpeed = Mathf.Clamp(MovementSpeed, 0.1f, 1.0f);
            }
        }
    }
}
